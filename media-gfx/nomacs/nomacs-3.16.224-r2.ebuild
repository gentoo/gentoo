# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLUGIN_PKG="${PN}-plugins-$(ver_cut 1-2)"
inherit cmake xdg-utils

DESCRIPTION="Qt-based image viewer"
HOMEPAGE="https://nomacs.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
plugins? ( https://github.com/${PN}/${PN}-plugins/archive/$(ver_cut 1-2).tar.gz -> ${PLUGIN_PKG}.tar.gz )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86 ~amd64-linux"
IUSE="+jpeg +opencv plugins raw +tiff zip"

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
	media-gfx/exiv2:=
	opencv? ( >=media-libs/opencv-3.4:= )
	raw? ( media-libs/libraw:= )
	tiff? (
		dev-qt/qtimageformats:5
		media-libs/tiff
	)
	zip? ( dev-libs/quazip:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/${P}/ImageLounge"

DOCS=( src/changelog.txt )

PATCHES=(
	"${FILESDIR}"/${P}-quazip1.patch
	"${FILESDIR}"/${P}-DkMath-ostream.patch
)

src_prepare() {
	if use plugins ; then
		rmdir plugins || die
		mv -v ../../${PLUGIN_PKG} plugins || die
		# Fix nomacs-plugins installation and search library directory
		sed -e "s:lib/nomacs-plugins:$(get_libdir)/nomacs-plugins:" \
			-i plugins/cmake/Utils.cmake || die
		sed -e "s:lib/nomacs-plugins:$(get_libdir)/nomacs-plugins:" \
			-i src/DkCore/DkPluginManager.cpp || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
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

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
