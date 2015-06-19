# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/crrcsim/crrcsim-0.9.12-r1.ebuild,v 1.1 2014/06/01 22:27:36 hasufell Exp $

EAPI=5
WANT_AUTOMAKE="1.10"
inherit autotools eutils gnome2-utils games

DESCRIPTION="model-airplane flight simulation program"
HOMEPAGE="http://sourceforge.net/projects/crrcsim/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="portaudio"

RDEPEND="sci-mathematics/cgal
	media-libs/plib
	media-libs/libsdl[X,sound,joystick,opengl,video]
	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-buildsystem.patch
	if has_version "sci-mathematics/cgal[gmp(+)]" ; then
		epatch "${FILESDIR}"/${PN}-cgal_gmp.patch
	fi
	eautoreconf
}

src_configure() {
	egamesconf \
		--datarootdir="${EPREFIX%/}/usr/share" \
		--datadir="${GAMES_DATADIR}" \
		--docdir="${EPREFIX%/}/usr/share/doc/${PF}" \
		$(use_with portaudio)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS HISTORY NEWS README
	doicon -s 32 packages/icons/${PN}.png
	make_desktop_entry ${PN}
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
