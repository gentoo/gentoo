# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A small and easy to use folding editor"
HOMEPAGE="http://www.moria.de/~michael/fe/"
SRC_URI="http://www.moria.de/~michael/fe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sendmail"

RDEPEND="sys-libs/ncurses:0=
	sendmail? ( virtual/mta )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8-makefile.patch
	"${FILESDIR}"/${P}-ar.patch
)

src_configure() {
	econf \
		$(use_enable sendmail) \
		LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake \
		prefix="${D}"/usr \
		datadir="${D}"/usr/share \
		MANDIR="${D}"/usr/share/man \
		install

	dodoc NEWS README
	docinto html
	dodoc fe.html
}
