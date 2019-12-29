# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Qt/C++ wrapper for ALSA sequencer"
HOMEPAGE="http://drumstick.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc fluidsynth pulseaudio"

BDEPEND="
	virtual/pkgconfig
	x11-misc/shared-mime-info
	doc? (
		app-doc/doxygen
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	fluidsynth? ( media-sound/fluidsynth )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

RESTRICT="test"

src_prepare() {
	cmake_src_prepare

	if ! use fluidsynth ; then
		sed -i -e "/pkg_check_modules(FLUIDSYNTH/d" \
			library/rt/CMakeLists.txt \
			library/rt-backends/CMakeLists.txt \
			utils/vpiano/CMakeLists.txt || die
	fi

	if ! use pulseaudio ; then
		sed -i -e "/pkg_check_modules(PULSE/d" CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		$(cmake_use_find_package doc Doxygen)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doxygen
}

src_install() {
	cmake_src_install

	if use doc ; then
		dodoc -r "${BUILD_DIR}"/doc/html
	fi
}
