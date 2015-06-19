# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen/xen-4.2.5-r11.ebuild,v 1.3 2015/06/16 07:09:10 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

if [[ $PV == *9999 ]]; then
	KEYWORDS=""
	REPO="xen-unstable.hg"
	EHG_REPO_URI="http://xenbits.xensource.com/${REPO}"
	S="${WORKDIR}/${REPO}"
	live_eclass="mercurial"
else
	KEYWORDS="amd64 x86"
	UPSTREAM_VER=9
	SECURITY_VER=3
	GENTOO_VER=

	[[ -n ${UPSTREAM_VER} ]] && \
		UPSTREAM_PATCHSET_URI="http://dev.gentoo.org/~dlan/distfiles/${P}-upstream-patches-${UPSTREAM_VER}.tar.xz"
	[[ -n ${SECURITY_VER} ]] && \
		SECURITY_PATCHSET_URI="http://dev.gentoo.org/~dlan/distfiles/${PN}-security-patches-${SECURITY_VER}.tar.xz"
	[[ -n ${GENTOO_VER} ]] && \
		GENTOO_PATCHSET_URI="http://dev.gentoo.org/~dlan/distfiles/${PN}-gentoo-patches-${GENTOO_VER}.tar.xz"
	SRC_URI="http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz
		${UPSTREAM_PATCHSET_URI}
		${SECURITY_PATCHSET_URI}
		${GENTOO_PATCHSET_URI}"
fi

inherit mount-boot flag-o-matic python-any-r1 toolchain-funcs eutils ${live_eclass}

DESCRIPTION="The Xen virtual machine monitor"
HOMEPAGE="http://xen.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug efi flask pae xsm"

DEPEND="${PYTHON_DEPS}
	efi? ( >=sys-devel/binutils-2.22[multitarget] )
	!efi? ( >=sys-devel/binutils-2.22[-multitarget] )"
RDEPEND=""
PDEPEND="~app-emulation/xen-tools-${PV}"

RESTRICT="test"

# Approved by QA team in bug #144032
QA_WX_LOAD="boot/xen-syms-${PV}"

REQUIRED_USE="
	flask? ( xsm )
	"

pkg_setup() {
	python-any-r1_pkg_setup
	if [[ -z ${XEN_TARGET_ARCH} ]]; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64; then
			export XEN_TARGET_ARCH="x86_64"
		else
			die "Unsupported architecture!"
		fi
	fi

	if use flask ; then
		export "XSM_ENABLE=y"
		export "FLASK_ENABLE=y"
	elif use xsm ; then
		export "XSM_ENABLE=y"
	fi
}

src_prepare() {
	# Upstream's patchset
	if [[ -n ${UPSTREAM_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		EPATCH_OPTS="-p1" \
			epatch "${WORKDIR}"/patches-upstream
	fi

	# Security patchset
	if [[ -n ${SECURITY_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		EPATCH_OPTS="-p1" \
			epatch "${WORKDIR}/patches-security/${PV}"
	fi

	# Gentoo's patchset
	if [[ -n ${GENTOO_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
			epatch "${WORKDIR}"/patches-gentoo
	fi

	# Drop .config and fix gcc-4.6
	epatch  "${FILESDIR}"/${PN/-pvgrub/}-4-fix_dotconfig-gcc.patch

	if use efi; then
		epatch "${FILESDIR}"/${PN}-4.2-efi.patch
		export EFI_VENDOR="gentoo"
		export EFI_MOUNTPOINT="boot"
	fi

	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \; || die "failed to re-set custom-cflags"
	fi

	# not strictly necessary to fix this
	sed -i 's/, "-Werror"//' "${S}/tools/python/setup.py" || die "failed to re-set setup.py"

	epatch_user
}

src_configure() {
	use debug && myopt="${myopt} debug=y"
	use pae && myopt="${myopt} pae=y"

	if use custom-cflags; then
		filter-flags -fPIE -fstack-protector
		replace-flags -O3 -O2
	else
		unset CFLAGS
	fi
}

src_compile() {
	# Send raw LDFLAGS so that --as-needed works
	emake CC="$(tc-getCC)" LDFLAGS="$(raw-ldflags)" LD="$(tc-getLD)" -C xen ${myopt}
}

src_install() {
	local myopt
	use debug && myopt="${myopt} debug=y"
	use pae && myopt="${myopt} pae=y"

	# The 'make install' doesn't 'mkdir -p' the subdirs
	if use efi; then
		mkdir -p "${D}"${EFI_MOUNTPOINT}/efi/${EFI_VENDOR} || die
	fi

	emake LDFLAGS="$(raw-ldflags)" DESTDIR="${D}" -C xen ${myopt} install
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " https://wiki.gentoo.org/wiki/Xen"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"

	use pae && ewarn "This is a PAE build of Xen. It will *only* boot PAE kernels!"
	use efi && einfo "The efi executable is installed in boot/efi/gentoo"
}
