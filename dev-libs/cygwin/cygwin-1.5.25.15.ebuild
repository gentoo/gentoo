# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cygwin/cygwin-1.5.25.15.ebuild,v 1.2 2012/06/06 03:27:49 zmedico Exp $

inherit flag-o-matic toolchain-funcs

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

W32API_BIN="3.12-1"
MY_P="${PN}-${PV%.*}-${PV##*.}"
DESCRIPTION="Linux-like environment for Windows"
HOMEPAGE="http://cygwin.com/"
SRC_URI="!crosscompile_opts_headers-only? ( ftp://sourceware.org/pub/cygwin/release/cygwin/${MY_P}-src.tar.bz2 )
	crosscompile_opts_headers-only? (
		ftp://sourceware.org/pub/cygwin/release/w32api/w32api-${W32API_BIN}.tar.bz2
		ftp://sourceware.org/pub/cygwin/release/cygwin/${MY_P}.tar.bz2
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

DEPEND=""

S=${WORKDIR}

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
}

src_unpack() {
	unpack ${A}
	if just_headers ; then
		mv usr/lib/w32api/* usr/lib/ || die
	else
		rm -rf ${MY_P}/etc # scrub garbage
	fi
}

src_compile() {
	if just_headers ; then
		return 0

		# steps to install via src pkg
		cd winsup/cygwin
		econf || die
	else
		CHOST=${CTARGET} strip-unsupported-flags
		mkdir "${WORKDIR}"/build
		cd "${WORKDIR}"/build
		ECONF_SOURCE=${S} \
		econf --prefix=/usr/${CTARGET}/usr || die
		emake || die
	fi
}

src_install() {
	if just_headers ; then
		# cygwin guys do not support bootstrapping.  thus the cygwin src pkg
		# blows and cannot be bootstrapped.  use the binaries -- the only
		# thing upstream supports.
		insinto /usr/${CTARGET}
		doins -r * || die
		return 0

		# steps to install via src pkg
		insinto /usr/${CTARGET}/usr/include
		doins -r winsup/w32api/include/* || die
		doins -r newlib/libc/include/* || die
		dosym usr/include /usr/${CTARGET}/sys-include
		cd winsup/cygwin
		emake install-headers tooldir="${D}"/usr/${CTARGET}/usr || die
	else
		cd "${WORKDIR}"/build
		emake install DESTDIR="${D}" || die
		env -uRESTRICT CHOST=${CTARGET} prepallstrip
	fi
}
