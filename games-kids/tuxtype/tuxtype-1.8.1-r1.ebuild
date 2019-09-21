# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Typing tutorial with lots of eye-candy"
HOMEPAGE="https://github.com/tux4kids/tuxtype"
SRC_URI="https://github.com/tux4kids/${PN}/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="svg"

DEPEND="acct-group/gamestat
	media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	svg? ( gnome-base/librsvg )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}-upstream-${PV}

src_configure() {
	econf \
		--localedir=/usr/share/locale \
		$(use_with svg rsvg)
}

src_install() {
	default
	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,INSTALL,ABOUT-NLS}*
	doicon ${PN}.ico
	make_desktop_entry ${PN} TuxTyping /usr/share/pixmaps/${PN}.ico
	keepdir /etc/${PN} /var/games/${PN}/words

	fowners root:gamestat /var/games/${PN} /usr/bin/${PN}
	fperms 660 /var/games/${PN}
	fperms 2755 /usr/bin/${PN}
}
