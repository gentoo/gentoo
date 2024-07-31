# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="Cross-platform libmpv-based multimedia player with uncluttered design"
HOMEPAGE="http://bakamplayer.u8sand.net/"
SRC_URI="https://github.com/u8sand/Baka-MPlayer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Baka-MPlayer-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-video/mpv:=[libmpv]
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc5.patch"
	"${FILESDIR}/${P}-mpv23.patch"
	"${FILESDIR}/${P}-playlist-regression.patch"
	"${FILESDIR}/${P}-libmpv-api2.patch"
)

src_prepare() {
	default
	# don't install license, man.gz, install the latter manually
	sed -e "/^INSTALLS/s:\sman\slicense::" \
		-e '/^manual.path/s:'${PN}':'${PF}':' \
		-i src/Baka-MPlayer.pro || die
	gunzip DOCS/baka-mplayer.1.gz || die
}

src_configure() {
	eqmake5 \
		INSTROOT="${D}" \
		CONFIG+=install_translations \
		lrelease="$(qt5_get_bindir)"/lrelease \
		lupdate="$(qt5_get_bindir)"/lupdate \
		src/Baka-MPlayer.pro
}

src_install() {
	default
	doman DOCS/baka-mplayer.1
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
