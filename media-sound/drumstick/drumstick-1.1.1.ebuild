# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils gnome2-utils

DESCRIPTION="Qt/C++ wrapper for ALSA sequencer"
HOMEPAGE="http://drumstick.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fluidsynth pulseaudio"

RESTRICT="test"

RDEPEND="
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
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-misc/shared-mime-info
	doc? (
		app-doc/doxygen
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	cmake-utils_src_prepare

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
		$(cmake-utils_use_find_package doc Doxygen)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_compile doxygen
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		dodoc -r "${BUILD_DIR}"/doc/html
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
