# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Puzzle game inspired by Atomix and written in SDL"
HOMEPAGE="https://lgames.sourceforge.io/LMarbles/"
SRC_URI="
	https://download.sourceforge.net/lgames/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

HTML_DOCS=( src/manual/. )

src_configure() {
	econf --localstatedir="${EPREFIX}"/var/games
}

src_install() {
	default

	fowners :gamestat /usr/bin/${PN} /var/games/lmarbles.prfs
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/lmarbles.prfs

	# gif format is not valid for XDG icons, and .desktop hardcodes icon path
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} LMarbles
	rm "${ED}"/usr/share/{applications/${PN}.desktop,icons/lmarbles48.gif} || die
}
