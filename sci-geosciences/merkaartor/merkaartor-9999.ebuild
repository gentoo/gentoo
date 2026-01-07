# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} != *9999* ]] ; then
	SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/openstreetmap/merkaartor.git"
	inherit git-r3
fi

DESCRIPTION="Qt based map editor for the openstreetmap.org project"
HOMEPAGE="https://www.merkaartor.be https://github.com/openstreetmap/merkaartor"

LICENSE="GPL-2"
SLOT="0"
IUSE="exif gps libproxy webengine zbar"

# bundles qtsingleapplication again, unfortunately
DEPEND="
	dev-libs/protobuf:=
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,network,widgets,xml]
	dev-qt/qtnetworkauth:6
	dev-qt/qtsvg:6
	sci-libs/gdal:=
	sci-libs/proj:=
	virtual/zlib:=
	exif? ( media-gfx/exiv2:= )
	gps? ( >=sci-geosciences/gpsd-3.17-r2:= )
	libproxy? ( >=net-libs/libproxy-0.5 )
	webengine? ( dev-qt/qtwebengine:6[widgets] )
	zbar? ( media-gfx/zbar )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

DOCS=( AUTHORS CHANGELOG )

PATCHES=(
	"${FILESDIR}"/${PN}-0.20.0-disable-git.patch # downstream patch
	# pending upstream PR: https://github.com/openstreetmap/merkaartor/pull/291
	"${FILESDIR}"/${PN}-0.20.0-GNUInstallDirs.patch
)

src_prepare() {
	# no Qt5 automagic, please
	sed -e "/^ *find_package.*QT NAMES/s/Qt5 //" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGEOIMAGE=$(usex exif)
		-DGPSD=$(usex gps)
		-DLIBPROXY=$(usex libproxy)
		-DWEBENGINE=$(usex webengine)
		-DZBAR=$(usex zbar)
		-DEXTRA_TESTS=OFF
	)

	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test
}
