# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev xdg

DESCRIPTION="A software to control DMX or analog lighting systems"
HOMEPAGE="https://www.qlcplus.org/"
SRC_URI="https://github.com/mcallegari/${PN}/archive/QLC+_${PV}.tar.gz"
S="${WORKDIR}/qlcplus-QLC-_${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/qttools:6[linguist]
"
RDEPEND="
	dev-embedded/libftdi:1
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtmultimedia:6
	dev-qt/qtserialport:6
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6
	media-libs/alsa-lib
	media-libs/libmad
	media-libs/libsndfile
	sci-libs/fftw:3.0=
	virtual/libusb:1
	virtual/libudev:=
"
IDEPEND="
	dev-util/desktop-file-utils
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	cmake_src_prepare

	sed -e "s|lib/${CMAKE_C_LIBRARY_ARCHITECTURE}|$(get_libdir)|g" \
		-i variables.cmake || die

	sed -e "s|/etc/udev/rules.d|$(get_udevdir)|g" \
		-i variables.cmake || die

	## Build script neither honors -DQT_DEFAULT_MAJOR_VERSION
	## nor -DQT_VERSION_MAJOR nor -DQT_MAJOR_VERSION. Let's patch
	## the CMakeLists file
	sed -e "s| Qt5 | |g" -e "s|\${QT_VERSION_MAJOR}|6|g" \
		-i CMakeLists.txt || die
}

pkg_postinst() {
	udev_reload

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_build check
}

pkg_postrm() {
	udev_reload

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
