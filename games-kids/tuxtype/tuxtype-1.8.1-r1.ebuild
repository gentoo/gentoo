# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils user

DESCRIPTION="Typing tutorial with lots of eye-candy"
HOMEPAGE="http://alioth.debian.org/projects/tux4kids/"
SRC_URI="http://alioth.debian.org/frs/download.php/3270/tuxtype_w_fonts-${PV}.tar.gz"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="svg"

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	svg? ( gnome-base/librsvg )"
RDEPEND=${DEPEND}

S=${WORKDIR}/tuxtype_w_fonts-${PV}

pkg_setup(){
	enewgroup gamestat 36
}

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
