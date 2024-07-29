# Copyright 2007-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info pam systemd udev

MY_P="${P}-23787635"

DESCRIPTION="Tools for VMware guests"
HOMEPAGE="https://github.com/vmware/open-vm-tools"
SRC_URI="https://github.com/vmware/open-vm-tools/releases/download/stable-${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="X +deploypkg +dnet doc +fuse gtkmm +icu multimon pam +resolutionkms +ssl +vgauth"
REQUIRED_USE="
	multimon? ( X )
	vgauth? ( ssl )"

RDEPEND="
	dev-libs/glib
	net-libs/libtirpc
	deploypkg? ( dev-libs/libmspack )
	fuse? ( sys-fs/fuse:0 )
	pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )
	ssl? ( dev-libs/openssl:= )
	vgauth? (
		dev-libs/libxml2
		dev-libs/xmlsec:=
	)
	X? (
		x11-libs/gdk-pixbuf-xlib
		x11-libs/gtk+:3
		x11-libs/libSM
		x11-libs/libXcomposite
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		gtkmm? (
			dev-cpp/gtkmm:3.0
			dev-libs/libsigc++:2
		)
		multimon? ( x11-libs/libXinerama )
	)
	dnet? ( dev-libs/libdnet )
	icu? ( dev-libs/icu:= )
	resolutionkms? (
		x11-libs/libdrm[video_cards_vmware]
		virtual/libudev
	)"
DEPEND="${RDEPEND}
	net-libs/rpcsvc-proto"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/10.1.0-Werror.patch
	"${FILESDIR}"/11.3.5-icu.patch
)

pkg_setup() {
	local CONFIG_CHECK="~VMWARE_BALLOON ~VMWARE_PVSCSI ~VMXNET3 ~VMWARE_VMCI ~VMWARE_VMCI_VSOCKETS ~FUSE_FS"
	use X && CONFIG_CHECK+=" ~DRM_VMWGFX"
	kernel_is -lt 5 5 || CONFIG_CHECK+=" ~X86_IOPL_IOPERM"
	linux-info_pkg_setup
}

src_prepare() {
	eapply -p2 "${PATCHES[@]}"
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-glibc-check
		--disable-tests
		--without-root-privileges
		$(use_enable multimon)
		$(use_with X x)
		$(use_with X gtk3)
		$(use_with gtkmm gtkmm3)
		$(use_enable doc docs)
		$(use_enable resolutionkms)
		$(use_enable deploypkg)
		$(use_with pam)
		$(use_enable vgauth)
		$(use_with dnet)
		$(use_with icu)
		--with-udev-rules-dir="$(get_udevdir)"/rules.d
	)
	# Avoid a bug in configure.ac
	use ssl || myeconfargs+=( --without-ssl )

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	if use pam; then
		rm "${ED}"/etc/pam.d/vmtoolsd || die
		pamd_mimic_system vmtoolsd auth account
	fi

	newinitd "${FILESDIR}/open-vm-tools.initd" vmware-tools
	newconfd "${FILESDIR}/open-vm-tools.confd" vmware-tools

	if use vgauth; then
		systemd_newunit "${FILESDIR}"/vmtoolsd.vgauth.service vmtoolsd.service
		systemd_dounit "${FILESDIR}"/vgauthd.service
	else
		systemd_dounit "${FILESDIR}"/vmtoolsd.service
	fi

	# Make fstype = vmhgfs-fuse work in fstab
	dosym vmhgfs-fuse /usr/bin/mount.vmhgfs-fuse

	if use X; then
		fperms 4711 /usr/bin/vmware-user-suid-wrapper
		dobin scripts/common/vmware-xdg-detect-de
	fi
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
