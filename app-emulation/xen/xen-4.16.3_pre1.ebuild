# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit flag-o-matic mount-boot python-any-r1 toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://xenbits.xen.org/xen.git"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm -x86"

	XEN_GENTOO_PATCHSET_NUM=2
	XEN_GENTOO_PATCHSET_BASE=4.16.1
	XEN_PRE_PATCHSET_NUM=0
	XEN_PRE_VERSION_BASE=4.16.2

	XEN_BASE_PV="${PV}"
	if [[ -n "${XEN_PRE_VERSION_BASE}" ]]; then
		XEN_BASE_PV="${XEN_PRE_VERSION_BASE}"
	fi

	SRC_URI="https://downloads.xenproject.org/release/xen/${XEN_BASE_PV}/xen-${XEN_BASE_PV}.tar.gz"

	if [[ -n "${XEN_PRE_PATCHSET_NUM}" ]]; then
		XEN_UPSTREAM_PATCHES_TAG="$(ver_cut 1-3)-pre-patchset-${XEN_PRE_PATCHSET_NUM}"
		XEN_UPSTREAM_PATCHES_NAME="xen-upstream-patches-${XEN_UPSTREAM_PATCHES_TAG}"
		SRC_URI+=" https://gitweb.gentoo.org/proj/xen-upstream-patches.git/snapshot/${XEN_UPSTREAM_PATCHES_NAME}.tar.bz2"
		XEN_UPSTREAM_PATCHES_DIR="${WORKDIR}/${XEN_UPSTREAM_PATCHES_NAME}"
	fi
	if [[ -n "${XEN_GENTOO_PATCHSET_NUM}" ]]; then
		XEN_GENTOO_PATCHES_TAG="$(ver_cut 1-3 ${XEN_GENTOO_PATCHSET_BASE})-gentoo-patchset-${XEN_GENTOO_PATCHSET_NUM}"
		XEN_GENTOO_PATCHES_NAME="xen-gentoo-patches-${XEN_GENTOO_PATCHES_TAG}"
		SRC_URI+=" https://gitweb.gentoo.org/proj/xen-gentoo-patches.git/snapshot/${XEN_GENTOO_PATCHES_NAME}.tar.bz2"
		XEN_GENTOO_PATCHES_DIR="${WORKDIR}/${XEN_GENTOO_PATCHES_NAME}"
	fi
fi

DESCRIPTION="The Xen virtual machine monitor"
HOMEPAGE="https://xenproject.org"

S="${WORKDIR}/xen-$(ver_cut 1-3 ${XEN_BASE_PV})"

LICENSE="GPL-2"
SLOT="0"
IUSE="+boot-symlinks debug efi flask"
REQUIRED_USE="arm? ( debug )"

DEPEND="${PYTHON_DEPS}
	efi? ( >=sys-devel/binutils-2.22[multitarget] )
	!efi? ( >=sys-devel/binutils-2.22 )
	flask? ( sys-apps/checkpolicy )"
RDEPEND=""
PDEPEND="~app-emulation/xen-tools-${PV}"

# no tests are available for the hypervisor
# prevent the silliness of /usr/lib/debug/usr/lib/debug files
# prevent stripping of the debug info from the /usr/lib/debug/xen-syms
RESTRICT="test splitdebug strip"

# Approved by QA team in bug #144032
QA_WX_LOAD="boot/xen-syms-${PV}"

pkg_setup() {
	python-any-r1_pkg_setup
	if [[ -z ${XEN_TARGET_ARCH} ]]; then
		if use amd64; then
			export XEN_TARGET_ARCH="x86_64"
		elif use arm; then
			export XEN_TARGET_ARCH="arm32"
		elif use arm64; then
			export XEN_TARGET_ARCH="arm64"
		else
			die "Unsupported architecture!"
		fi
	fi
}

src_prepare() {
	if [[ -v XEN_UPSTREAM_PATCHES_DIR ]]; then
		eapply "${XEN_UPSTREAM_PATCHES_DIR}"
	fi

	if [[ -v XEN_GENTOO_PATCHES_DIR ]]; then
		eapply "${XEN_GENTOO_PATCHES_DIR}"
	fi

	# Symlinks do not work on fat32 volumes # 829765
	if ! use boot-symlinks || use efi; then
		eapply "${XEN_GENTOO_PATCHES_DIR}"/no-boot-symlinks/${PN}-4.16-no-symlinks.patch
	fi

	# Workaround new gcc-11 options
	sed -e '/^CFLAGS/s/-Werror//g' -i xen/Makefile || die

	# Drop .config
	sed -e '/-include $(XEN_ROOT)\/.config/d' -i Config.mk || die "Couldn't	drop"

	if use efi; then
		export EFI_VENDOR="gentoo"
		export EFI_MOUNTPOINT="/boot"
	fi

	default
}

xen_make() {
	# Setting clang to either 'y' or 'n' tells Xen's build system
	# whether or not clang is used.
	local clang=n
	if tc-is-clang; then
		clang=y
	fi

	# Send raw LDFLAGS so that --as-needed works
	emake \
		V=1 \
		LDFLAGS="$(raw-ldflags)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		HOSTCXX="$(tc-getBUILD_CXX)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		RANLIB="$(tc-getRANLIB)" \
		clang="${clang}" \
		"$@"
}

src_configure() {
	cd xen || die

	touch gentoo-config || die
	if use arm; then
	   echo "CONFIG_EARLY_PRINTK=sun7i" >> gentoo-config || die
	fi
	if use debug; then
		cat <<-EOF >> gentoo-config || die
		CONFIG_DEBUG=y
		CONFIG_CRASH_DEBUG=y
EOF
	fi
	if use flask; then
		echo "CONFIG_XSM=y" >> gentoo-config || die
	fi

	# remove flags
	unset CFLAGS

	tc-ld-disable-gold # Bug 700374

	xen_make KCONFIG_ALLCONFIG=gentoo-config alldefconfig
}

src_compile() {
	xen_make -C xen
}

src_install() {
	# The 'make install' doesn't 'mkdir -p' the subdirs
	if use efi; then
		mkdir -p "${D}"${EFI_MOUNTPOINT}/efi/${EFI_VENDOR} || die
	fi

	xen_make DESTDIR="${D}" -C xen install

	# make install likes to throw in some extra EFI bits if it built
	use efi || rm -rf "${D}/usr/$(get_libdir)/efi"
}
