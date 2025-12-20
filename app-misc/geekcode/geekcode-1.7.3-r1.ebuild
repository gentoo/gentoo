# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Geek code generator"
HOMEPAGE="https://sourceforge.net/projects/geekcode"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~mips ppc ppc64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-exit.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	sed -i Makefile -e 's| -o | ${LDFLAGS}&|g' || die "sed Makefile"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin geekcode
	dodoc CHANGES README geekcode.txt
}
