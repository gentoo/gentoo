# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/glob2/glob2-0.9.4.4-r1.ebuild,v 1.6 2015/05/19 15:54:53 mr_bones_ Exp $

EAPI=5
inherit eutils gnome2-utils scons-utils games

DESCRIPTION="Real Time Strategy (RTS) game involving a brave army of globs"
HOMEPAGE="http://globulation2.org/"
SRC_URI="mirror://nongnu/glob2/${PV:0:5}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.34[threads]
	dev-libs/fribidi
	media-libs/libsdl[opengl]
	media-libs/libvorbis
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/speex
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{gcc44,scons-blows,underlinking,gcc49}.patch
}

src_configure() {
	myesconsargs=(
		INSTALLDIR="${GAMES_DATADIR}"/${PN}
		DATADIR="${GAMES_DATADIR}"/${PN}
	)
	escons data
}

src_compile() {
	escons
}

src_install() {
	dogamesbin src/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r campaigns data maps scripts
	find "${D}/${GAMES_DATADIR}"/${PN} -name SConscript -exec rm -f '{}' +
	newicon -s 48 data/icons/glob2-icon-48x48.png ${PN}.png
	make_desktop_entry glob2 "Globulation 2"
	dodoc README*
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
