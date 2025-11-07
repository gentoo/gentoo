# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release" # buildsys: what a mess
PLUGIN_PKG="${PN}-plugins-${PV}"
inherit cmake xdg

DESCRIPTION="Qt-based image viewer"
HOMEPAGE="https://nomacs.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
CMAKE_USE_DIR="${S}/ImageLounge"

LICENSE="GPL-3+"
SLOT="0"

if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86 ~amd64-linux"
fi

IUSE="+opencv plugins raw +tiff test zip"
REQUIRED_USE="
	raw? ( opencv )
	tiff? ( opencv )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,widgets]
	dev-qt/qtsvg:6
	media-gfx/exiv2:=
	opencv? ( >=media-libs/opencv-3.4:= )
	raw? ( media-libs/libraw:= )
	tiff? (
		dev-qt/qtimageformats:6
		media-libs/tiff:=
	)
	zip? ( dev-libs/quazip:0=[qt6(+)] )
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

DOCS=( src/changelog.txt )

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6
		-DENABLE_CODE_COV=OFF
		-DUSE_SYSTEM_QUAZIP=ON
		-DENABLE_TRANSLATIONS=ON
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_PLUGINS=$(usex plugins)
		-DENABLE_RAW=$(usex raw)
		-DENABLE_TESTING=$(usex test)
		-DENABLE_TIFF=$(usex tiff)
		-DENABLE_QUAZIP=$(usex zip)
	)
	cmake_src_configure
}

src_test() {
	cmake_build core_tests
	cmake_src_test
}
