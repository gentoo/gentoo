# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release" # buildsys: what a mess
PLUGIN_PKG="${PN}-plugins-$(ver_cut 1-2)"
inherit cmake xdg

DESCRIPTION="Qt-based image viewer"
HOMEPAGE="https://nomacs.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
plugins? ( https://github.com/${PN}/${PN}-plugins/archive/$(ver_cut 1-2).tar.gz -> ${PLUGIN_PKG}.tar.gz )"
CMAKE_USE_DIR="${S}/ImageLounge"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86 ~amd64-linux"
IUSE="+opencv plugins raw +tiff zip"

REQUIRED_USE="
	raw? ( opencv )
	tiff? ( opencv )
"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg]
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-gfx/exiv2:=
	opencv? ( >=media-libs/opencv-3.4:= )
	raw? ( media-libs/libraw:= )
	tiff? (
		dev-qt/qtimageformats:5
		media-libs/tiff:=
	)
	zip? ( dev-libs/quazip:0=[qt5(+)] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

DOCS=( src/changelog.txt )

PATCHES=(
	"${FILESDIR}"/${P}-libdir.patch
	"${FILESDIR}"/${P}-exiv2-0.28.patch # bug 906488
)

src_prepare() {
	if use plugins ; then
		rmdir ImageLounge/plugins || die
		mv -v ../${PLUGIN_PKG} ImageLounge/plugins || die
	fi

	# from git master # reuse existing patches w/o paths adjusted
	pushd "ImageLounge" > /dev/null || die
		eapply "${FILESDIR}"/${P}-quazip1.patch
		eapply "${FILESDIR}"/${P}-DkMath-ostream.patch
	popd > /dev/null || die

	use plugins && eapply "${FILESDIR}"/${P}-libdir-plugins.patch

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT_QMAKE_EXECUTABLE=qmake5 # bug 847112
		-DENABLE_CODE_COV=OFF
		-DUSE_SYSTEM_QUAZIP=ON
		-DENABLE_TRANSLATIONS=ON
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_PLUGINS=$(usex plugins)
		-DENABLE_RAW=$(usex raw)
		-DENABLE_TIFF=$(usex tiff)
		-DENABLE_QUAZIP=$(usex zip)
	)
	cmake_src_configure
}
