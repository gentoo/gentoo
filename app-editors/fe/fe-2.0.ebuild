# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A small and easy to use folding editor"
HOMEPAGE="http://www.moria.de/~michael/fe/"
SRC_URI="http://www.moria.de/~michael/fe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sendmail"

RDEPEND="sys-libs/ncurses:0=
	sendmail? ( virtual/mta )"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}"/${PN}-1.8-makefile.patch)

src_configure() {
	econf $(use_enable sendmail)
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
