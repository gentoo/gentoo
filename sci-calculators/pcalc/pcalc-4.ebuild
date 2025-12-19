# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="the programmers calculator"
HOMEPAGE="https://github.com/vapier/pcalc"
SRC_URI="https://downloads.sourceforge.net/pcalc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ~ppc ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-alternatives/lex"

src_prepare() {
	default
	sed -i -e "s:/usr:${EPREFIX}/usr:g" Makefile || die
}

src_configure() {
	tc-export CC
}
