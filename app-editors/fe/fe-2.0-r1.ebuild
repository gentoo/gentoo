# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="A small and easy to use folding editor"
HOMEPAGE="http://www.moria.de/~michael/fe/"
SRC_URI="http://www.moria.de/~michael/fe/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="sendmail"

RDEPEND="sys-libs/ncurses:0=
	sendmail? ( virtual/mta )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8-makefile.patch
	"${FILESDIR}"/${P}-ar.patch
	"${FILESDIR}"/${P}-ncurses.patch
)

src_prepare() {
	default
	AT_NOEAUTOHEADER=yes eautoreconf
}

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
		datarootdir="${D}"/usr/share \
		MANDIR="${D}"/usr/share/man \
		install

	dodoc NEWS README
	docinto html
	dodoc fe.html
}
