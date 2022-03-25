# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple RSS and Atom parser"
HOMEPAGE="https://codemadness.org/sfeed-simple-feed-parser.html"
SRC_URI="https://codemadness.org/releases/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ncurses"

DEPEND="ncurses? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}
	net-misc/curl
	sys-apps/coreutils
	sys-libs/glibc
	virtual/awk
	www-client/lynx
	x11-misc/xclip
	x11-misc/xdg-utils"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-1.2-ldflags.patch"
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		AR="$(tc-getAR)" \
		SFEED_CURSES=$(usex ncurses "sfeed_curses" "")
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		MANPREFIX="${EPREFIX}/usr/share/man" \
		DOCPREFIX="${EPREFIX}/usr/share/doc/${P}" \
		SFEED_CURSES=$(usex ncurses "sfeed_curses" "") \
		install
}
