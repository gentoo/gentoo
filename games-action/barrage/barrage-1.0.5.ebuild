# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="Violent point-and-click shooting game"
HOMEPAGE="http://lgames.sourceforge.net/Barrage/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

src_configure() {
	econf --localstatedir="${EPREFIX}"/var/games
}

src_compile() {
	default

	# generated .desktop hardcodes icon path (and in wrong location)
	sed -i "/^Icon=/s|=.*|=${PN}|" ${PN}.desktop || die
}

src_install() {
	default

	fowners :gamestat /{usr/bin/${PN},var/games/${PN}.hscr}
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.hscr

	rm "${ED}"/usr/share/icons/${PN}48.png || die
	newicon ${PN}48.png ${PN}.png
}
