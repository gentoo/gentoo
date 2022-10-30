# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs savedconfig optfeature

DESCRIPTION="Simple RSS and Atom parser"
HOMEPAGE="https://codemadness.org/sfeed-simple-feed-parser.html"
SRC_URI="https://codemadness.org/releases/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc"

THEMES=( mono{,-highlight} newsboat templeos )
IUSE="+ncurses +${THEMES[@]/#/theme-}"
REQUIRED_USE="ncurses? ( ^^ ( "${THEMES[@]/#/theme-}" ) )"

DEPEND="ncurses? ( sys-libs/ncurses:= )"
RDEPEND="${DEPEND}"
BDEPEND="ncurses? ( virtual/pkgconfig )"

src_configure() {
	local name
	for name in "${THEMES[@]}"; do
		use "theme-${name}" && SFEED_THEME="${name//-/_}"
	done

	restore_config $(printf "themes/%s.h " "${THEMES[@]//-/_}")
}

src_compile() {
	local ncurses_ldflags=""
	use ncurses && ncurses_ldflags="$($(tc-getPKG_CONFIG) --libs ncurses || die)"

	emake \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		AR="$(tc-getAR)" \
		SFEED_CURSES="$(usex ncurses "sfeed_curses" "")" \
		SFEED_THEME="${SFEED_THEME}" \
		SFEED_CURSES_LDFLAGS="${LDFLAGS} ${ncurses_ldflags}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		MANPREFIX="${EPREFIX}/usr/share/man" \
		DOCPREFIX="${EPREFIX}/usr/share/doc/${PF}" \
		SFEED_CURSES="$(usex ncurses "sfeed_curses" "")" \
		install

	save_config $(printf "themes/%s.h " "${THEMES[@]//-/_}")
}

pkg_postinst() {
	local optmsg

	if use ncurses; then
		optmsg="yanking the URL or enclosure in sfeed_curses. "
		optmsg+="See \$SFEED_YANKER to change it."
		optfeature "${optmsg}" x11-misc/xclip

		optmsg="plumbing the URL or enclosure in sfeed_curses. "
		optmsg+="See \$SFEED_PLUMBER to change it."
		optfeature "${optmsg}" x11-misc/xdg-utils
	fi

	optmsg="converting HTML content via sfeed_content. "
	optmsg+="See the ENVIRONMENT VARIABLES section in the man page to change it."
	optfeature "${optmsg}" www-client/lynx

	optmsg="fetching feeds. Used by sfeed_update as default. "
	optmsg+="See OVERRIDE FUNCTIONS section on sfeedrc manpage to change it."
	optfeature "${optmsg}" net-misc/curl
}
