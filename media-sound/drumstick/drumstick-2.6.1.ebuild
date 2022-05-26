# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt/C++ wrapper for ALSA sequencer"
HOMEPAGE="https://drumstick.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fluidsynth network pulseaudio"

RESTRICT="test"

BDEPEND="
	dev-libs/libxslt
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	x11-misc/shared-mime-info
	doc? (
		app-doc/doxygen[dot]
		app-text/docbook-xsl-stylesheets
	)
"
DEPEND="
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	fluidsynth? ( media-sound/fluidsynth )
	network? ( dev-qt/qtnetwork:5 )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS readme.md TODO )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DUSE_DBUS=ON
		-DUSE_FLUIDSYNTH=$(usex fluidsynth)
		-DUSE_NETWORK=$(usex network)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DBUILD_DOCS=$(usex doc)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doxygen
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install
}
