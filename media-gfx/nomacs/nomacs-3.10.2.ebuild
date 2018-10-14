# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

DESCRIPTION="Qt-based image viewer"
HOMEPAGE="https://nomacs.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="+jpeg +opencv raw tiff zip"

REQUIRED_USE="
	raw? ( opencv )
	tiff? ( opencv )
"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg?]
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	>=media-gfx/exiv2-0.25:=
	opencv? ( media-libs/opencv:=[-qt4(-)] )
	raw? ( >=media-libs/libraw-0.14:= )
	tiff? (
		dev-qt/qtimageformats:5
		media-libs/tiff:0
	)
	zip? ( >=dev-libs/quazip-0.7.2[qt5(+)] )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/${P}/ImageLounge"

DOCS=( src/changelog.txt )

PATCHES=( "${FILESDIR}/${P}_fix_move_crop_area_tooltip.patch" )

src_prepare() {
	cmake-utils_src_prepare

	# fix build with quazip-0.7.2 - bug 598354
	sed -i -e "s/find_package(QuaZIP/find_package(QuaZip5/" cmake/Unix.cmake || die
	sed -e "s/include <quazip/&5/" \
		-i src/DkCore/DkImageLoader.cpp \
		-i src/DkCore/DkImageContainer.cpp \
		-i src/DkCore/DkBasicLoader.cpp \
		-i src/DkGui/DkDialog.cpp || die

	sed -i -e "/setup_target_for_coverage/s/^/#/" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_RAW=$(usex raw)
		-DENABLE_TIFF=$(usex tiff)
		-DENABLE_QUAZIP=$(usex zip)
		-DUSE_SYSTEM_QUAZIP=ON
		-DENABLE_TRANSLATIONS=ON
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
