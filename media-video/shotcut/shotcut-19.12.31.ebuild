# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org/ https://github.com/mltframework/shotcut/"
SRC_URI="https://github.com/mltframework/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=media-libs/mlt-6.16.0-r1[ffmpeg,frei0r,jack,qt5,sdl,xml]
	media-libs/webvfx
	media-video/ffmpeg
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/qtx11extras:5
"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols:5
	virtual/jack
"

src_prepare() {
	default

	sed -i -e '/QT.*private/d' \
		src/src.pro || die
}

src_configure() {
	append-cxxflags -Wno-deprecated-declarations

	eqmake5 \
		PREFIX="${EPREFIX}/usr" \
		SHOTCUT_VERSION="${PV}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
