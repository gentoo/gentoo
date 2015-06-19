# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/dustrac/dustrac-1.11.0.ebuild,v 1.1 2015/05/26 21:24:24 mr_bones_ Exp $

EAPI=5
inherit eutils gnome2-utils cmake-utils games

DESCRIPTION="Tile-based, cross-platform 2D racing game"
HOMEPAGE="http://dustrac.sourceforge.net/"
SRC_URI="mirror://sourceforge/dustrac/${P}.tar.gz"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtxml:5
	dev-qt/linguist-tools:5
	media-libs/libvorbis
	media-libs/openal
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch
}

src_configure() {
	# -DGLES=ON didn't build for me but maybe just need use flags on some QT package?
	# Maybe add a local gles use flag
	local mycmakeargs=(
		-DReleaseBuild=ON
		-DDATA_PATH="${GAMES_DATADIR}/${PN}"
		-DBIN_PATH="${GAMES_BINDIR}"
		-DDOC_PATH=/usr/share/doc/${PF}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dosym /usr/share/fonts/ubuntu-font-family/UbuntuMono-B.ttf "${GAMES_DATADIR}/${PN}/fonts/UbuntuMono-B.ttf"
	dosym /usr/share/fonts/ubuntu-font-family/UbuntuMono-R.ttf "${GAMES_DATADIR}/${PN}/fonts/UbuntuMono-R.ttf"
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
