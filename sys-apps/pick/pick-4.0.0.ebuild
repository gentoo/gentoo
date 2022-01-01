# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="a fuzzy search tool for the command-line"
HOMEPAGE="https://github.com/mptre/pick"
SRC_URI="https://github.com/mptre/pick/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.0-tinfo.patch"
)

src_configure() {
	# not autoconf
	./configure || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" BINDIR=/usr/bin MANDIR=/usr/share/man install
	dodoc CHANGELOG.md
}
