# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
MODULES_OPTIONAL_USE="modules"

inherit autotools flag-o-matic linux-mod pam systemd toolchain-funcs user

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="https://github.com/vmware/open-vm-tools"
MY_P="${P}-6677369"
SRC_URI="https://github.com/vmware/open-vm-tools/releases/download/stable-${PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X doc grabbitmqproxy icu pam +pic vgauth xinerama"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/libdnet
	net-libs/libtirpc:0=
	sys-fs/fuse:0
	>=sys-process/procps-3.3.2
	grabbitmqproxy? ( dev-libs/openssl:0 )
	icu? ( dev-libs/icu:= )
	pam? ( virtual/pam )
	vgauth? (
		dev-libs/openssl:0
		dev-libs/xerces-c
		dev-libs/xml-security-c
	)
	X? (
		dev-cpp/gtkmm:3.0
		x11-libs/gtk+:3
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXtst
		xinerama? ( x11-libs/libXinerama )
	)
"

DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	net-libs/rpcsvc-proto
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/10.1.0-mount.vmhgfs.patch"
	"${FILESDIR}/10.1.0-vgauth.patch"
	"${FILESDIR}/10.1.0-Werror.patch"
)

pkg_setup() {
	linux-info_get_any_version
	local CONFIG_CHECK="~VMWARE_BALLOON ~VMWARE_PVSCSI ~VMXNET3"
	use X && CONFIG_CHECK+=" ~DRM_VMWGFX"
	kernel_is -lt 3 9 || CONFIG_CHECK+=" ~VMWARE_VMCI ~VMWARE_VMCI_VSOCKETS"
	kernel_is -lt 3 || CONFIG_CHECK+=" ~FUSE_FS"
	if use modules; then
		linux-mod_pkg_setup
	else
		linux-info_pkg_setup
	fi
}

src_prepare() {
	eapply -p2 "${PATCHES[@]}"
	eapply_user
	eautoreconf
}

src_configure() {
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags libtirpc)"
	export LIBVMTOOLS_LIBADD="$($(tc-getPKG_CONFIG) --libs libtirpc)"
	local myeconfargs=(
		--disable-deploypkg
		--disable-static
		--disable-tests
		--with-procps
		--with-dnet
		$(use_enable doc docs)
		$(use_enable grabbitmqproxy)
		$(use_enable vgauth)
		$(use_enable xinerama multimon)
		$(use_with icu)
		$(use_with pam)
		$(use_with pic)
		--without-gtk2
		--without-gtkmm
		$(use_with X gtk3)
		$(use_with X gtkmm3)
		$(use_with X x)

		# configure locates the kernel object directory by looking for
		# "/lib/modules/${KERNEL_RELEASE}/build".
		# This will fail if the user is building against an uninstalled kernel.
		# Fixing this would mean reworking the build system.
		$(use_with modules kernel-modules)
		--without-root-privileges
		--with-kernel-release="${KV_FULL}"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	use modules && set_arch_to_kernel
	default
}

src_install() {
	default
	prune_libtool_files --modules

	if use pam; then
		rm "${ED%/}"/etc/pam.d/vmtoolsd || die
		pamd_mimic_system vmtoolsd auth account
	fi

	newinitd "${FILESDIR}/open-vm-tools.initd" vmware-tools
	newconfd "${FILESDIR}/open-vm-tools.confd" vmware-tools
	systemd_dounit "${FILESDIR}"/vmtoolsd.service

	# Replace mount.vmhgfs with a wrapper
	mv "${ED%/}"/usr/sbin/{mount.vmhgfs,hgfsmounter} || die
	dosbin "${FILESDIR}/mount.vmhgfs"

	# Make fstype = vmhgfs-fuse work in fstab
	dosym vmhgfs-fuse /usr/bin/mount.vmhgfs-fuse

	if use X; then
		fperms 4711 /usr/bin/vmware-user-suid-wrapper
		dobin scripts/common/vmware-xdg-detect-de

		elog "To be able to use the drag'n'drop feature of VMware for file"
		elog "exchange, please add the users to the 'vmware' group."
	fi
}

pkg_postinst() {
	enewgroup vmware
	linux-mod_pkg_postinst
}
