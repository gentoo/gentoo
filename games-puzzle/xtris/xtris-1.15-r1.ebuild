# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit desktop toolchain-funcs

DESCRIPTION="A networked Tetris-like game"
HOMEPAGE="http://www.iagora.com/~espel/xtris/xtris.html"
SRC_URI="http://www.iagora.com/~espel/xtris/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	emake \
		CC=$(tc-getCC) \
		BINDIR=/usr/bin \
		MANDIR=/usr/share/man \
		CFLAGS="${CFLAGS}" \
		EXTRALIBS="${LDFLAGS}"
}

src_install() {
	dobin xtris xtserv xtbot
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} xtris ${PN}
	doman xtris.6 xtserv.6 xtbot.6
	dodoc ChangeLog PROTOCOL README
}
