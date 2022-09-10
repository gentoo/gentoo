# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="https://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/bzip2:=
	>=dev-libs/quazip-1.2:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/speex
	media-libs/speexdsp
	virtual/libusb:1
"
DEPEND="
	${RDEPEND}
	dev-qt/qttest:5
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/RockboxUtility-v${PV}-src"
CMAKE_USE_DIR="${S}/utils"

PATCHES=(
	"${FILESDIR}"/${P}-system-quazip.patch
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-headers.patch
)

src_prepare() {
	cmake_src_prepare
	rm -rv utils/rbutilqt/{quazip,zlib}/ || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCCACHE_PROGRAM=FALSE
		-DUSE_SYSTEM_QUAZIP=ON
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/{ipodpatcher,sansapatcher,rbutilqt/RockboxUtility}
	newicon -s scalable docs/logo/rockbox-clef.svg rockbox.svg
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox
	dodoc utils/rbutilqt/changelog.txt
}
