# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="The notorious fortune program"
HOMEPAGE="http://www.redellipse.net/code/fortune"
SRC_URI="http://www.redellipse.net/code/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa m68k ~mips ppc64 sh x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="offensive elibc_glibc"

DEPEND="app-text/recode"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/01_all_fortune_all-fix.patch

	sed -i \
		-e 's:/games::' \
		-e 's:/fortunes:/fortune:' \
		-e '/^FORTDIR=/s:=.*:=$(prefix)/usr/bin:' \
		-e '/^all:/s:$: fortune/fortune.man:' \
		-e "/^OFFENSIVE=/s:=.*:=`use offensive && echo 1 || echo 0`:" \
		Makefile || die "sed Makefile failed"

	if ! use elibc_glibc ; then
		[[ ${CHOST} == *-*bsd* ]] && local reglibs="-lcompat"
		[[ ${CHOST} == *-darwin* ]] && local reglibs="-lc"
		has_version "app-text/recode[nls]" && reglibs="${reglibs} -lintl"
		sed -i \
			-e "/^REGEXLIBS=/s:=.*:= ${reglibs}:" \
			Makefile \
			|| die "sed REGEXLIBS failed"
	fi
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's:u_int:uint:g' util/strfile.h || die "sed strfile.h failed"
	fi
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/-DBSD_REGEX/-DPOSIX_REGEX/' Makefile || die "sed Makefile failed"
	fi
}

src_compile() {
	local myrex=
	[[ ${CHOST} == *-interix* ]] && myrex="REGEXDEFS=-DNO_REGEX"
	emake prefix="${EPREFIX}" CC="$(tc-getCC)" $myrex
}

src_install() {
	emake prefix="${ED}" install
	dodoc ChangeLog INDEX Notes Offensive README TODO cookie-files
}
