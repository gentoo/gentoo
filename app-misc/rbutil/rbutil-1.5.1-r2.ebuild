# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="https://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"
S="${WORKDIR}/RockboxUtility-v${PV}-src"
CMAKE_USE_DIR="${S}/utils"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/bzip2:=
	>=dev-libs/quazip-1.3-r2:=[qt6(+)]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,ssl,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
	media-libs/speex
	media-libs/speexdsp
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-system-quazip.patch
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-headers.patch
)

CMAKE_SKIP_TESTS=( "TestHttpGet\." )

src_prepare() {
	cmake_src_prepare
	rm -rv utils/rbutilqt/{quazip,zlib}/ || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCCACHE_PROGRAM=FALSE
		-DQT_DIR="${EPREFIX}/usr/$(get_libdir)/cmake/Qt6" # Force 6 over 5.
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/{ipodpatcher,sansapatcher,rbutilqt/RockboxUtility}
	newicon -s scalable docs/logo/rockbox-clef.svg rockbox.svg
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox
	dodoc utils/rbutilqt/changelog.txt
}
