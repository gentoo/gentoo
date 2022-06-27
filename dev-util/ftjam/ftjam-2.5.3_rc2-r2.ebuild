# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=$(ver_rs 3 "")

DESCRIPTION="A 100% compatible, enhanced implementation of the make alternative Jam"
HOMEPAGE="http://freetype.sourceforge.net/jam/index.html"
SRC_URI="http://david.freetype.org/jam/ftjam-${MY_PV}.tar.bz2"

LICENSE="perforce GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="sys-devel/bison"

S=${WORKDIR}/${PN}-${MY_PV}

DOCS=( README README.ORG CHANGES RELNOTES )
HTML_DOCS=( Jam.html Jambase.html Jamfile.html )

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.3-nostrip.patch
	"${FILESDIR}"/${PN}-2.5.3-i-hate-yacc.patch
	"${FILESDIR}"/${PN}-2.5.3-false-flags.patch
)

src_prepare() {
	default
	tc-export CC
}
