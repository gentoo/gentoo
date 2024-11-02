# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit cmake xdg

DESCRIPTION="Qt/C++ wrapper for ALSA sequencer"
HOMEPAGE="https://drumstick.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="alsa doc fluidsynth test"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-libs/libxslt
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	virtual/pkgconfig
	x11-misc/shared-mime-info
	doc? (
		app-text/doxygen[dot]
		app-text/docbook-xsl-stylesheets
	)
"
DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qttools-${QTMIN}:6[designer]
	alsa? ( media-libs/alsa-lib )
	fluidsynth? ( media-sound/fluidsynth:= )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS readme.md TODO )

src_configure() {
	local mycmakeargs=(
		-DBUILD_RT=ON
		-DUSE_NETWORK=ON # just to satisfy BUILD_RT w/o REQUIRED_USE
		-DUSE_PIPEWIRE=OFF # only affects fluidsynth RT backend
		-DUSE_DBUS=ON
		-DUSE_QT5=OFF # bug 919682
		-DUSE_SONIVOX=OFF # not packaged, bug #865259
		-DUSE_PULSEAUDIO=OFF # requires Sonivox
		-DBUILD_ALSA=$(usex alsa)
		-DBUILD_DOCS=$(usex doc)
		-DUSE_FLUIDSYNTH=$(usex fluidsynth)
		-DBUILD_TESTING=$(usex test)
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
