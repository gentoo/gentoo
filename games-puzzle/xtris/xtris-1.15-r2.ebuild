# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="A networked Tetris-like game"
HOMEPAGE="http://www.iagora.com/~espel/xtris/xtris.html"
SRC_URI="http://www.iagora.com/~espel/xtris/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-implicit-function-decl-time.patch
	"${FILESDIR}"/${P}-gcc15.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
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
