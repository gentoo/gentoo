# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils xdg

DESCRIPTION="Multimedia interpreter for TADS text adventures"
HOMEPAGE="https://realnc.github.io/qtads"
SRC_URI="https://github.com/realnc/qtads/releases/download/v${PV}/${P}-source.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sound"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwidgets:5
	sound? (
		media-libs/libsdl2[sound]
		media-libs/libsndfile
		media-libs/libvorbis
		media-sound/fluidsynth:0=
		media-sound/mpg123
	)
"
RDEPEND=${DEPEND}

src_configure() {
	eqmake5 \
		PREFIX="${EPREFIX}/usr" \
		$(usex !sound CONFIG+=disable-audio '') \
		-after CONFIG-=silent
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
