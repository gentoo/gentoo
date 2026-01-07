# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A usenet binary autoposter for unix"
HOMEPAGE="http://newspost.unixcab.org/"
SRC_URI="http://newspost.unixcab.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	# Should fix some problems with unexpected server replies, cf. bug 185468
	"${FILESDIR}"/${P}-nntp.patch
	"${FILESDIR}"/CAN-2005-0101.patch
	"${FILESDIR}"/${P}-glibc-2.10.patch
)

src_prepare() {
	default

	sed -e "/-strip newspost/d" -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LIBS="${LDFLAGS}" main
}

src_install() {
	dobin newspost
	doman man/man1/newspost.1
	dodoc CHANGES README
}
