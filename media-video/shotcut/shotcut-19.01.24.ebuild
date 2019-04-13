# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils xdg

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org/"
SRC_URI="https://github.com/mltframework/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/ladspa-sdk
	media-libs/libsdl:0
	media-libs/libvpx
	>=media-libs/mlt-6.10.0-r1[ffmpeg,frei0r,qt5,sdl,xml]
	media-libs/x264
	media-plugins/frei0r-plugins
	media-sound/lame
	media-video/ffmpeg
	virtual/jack
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

src_prepare() {
	local mylrelease="$(qt5_get_bindir)/lrelease"
	"${mylrelease}" "${S}/src/src.pro" || die "preparing locales failed"

	default
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
