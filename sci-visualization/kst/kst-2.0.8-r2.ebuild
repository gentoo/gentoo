# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=Kst-${PV}
inherit cmake flag-o-matic xdg-utils

DESCRIPTION="Fast real-time large-dataset viewing and plotting tool"
HOMEPAGE="https://kst-plot.kde.org/ https://invent.kde.org/graphics/kst-plot"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test"

RESTRICT="test"

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sci-libs/cfitsio:=
	sci-libs/getdata[cxx]
	sci-libs/gsl:=
	sci-libs/matio:=
	sci-libs/netcdf-cxx:3
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS README.kstScript )

PATCHES=(
	"${FILESDIR}/${P}-includes.patch"
	"${FILESDIR}/${P}-qt-5.11.patch"
	"${FILESDIR}/${P}-gsl-2.0.patch"
	"${FILESDIR}/${P}-cmake-3.20.patch" # bug 778560
	"${FILESDIR}/${P}-getdata-drop-bogus-lib_debug.patch" # bug 593848
	"${FILESDIR}/${P}-qt-5.15.patch" # bug 593848
)

src_configure() {
	# -Werror=odr, -Werror=lto-type=-mismatch
	# https://bugs.gentoo.org/863296
	# https://bugs.kde.org/show_bug.cgi?id=484572
	filter-lto

	local mycmakeargs=(
		-Dkst_install_libdir="$(get_libdir)"
		-Dkst_pch=OFF
		-Dkst_qt5=ON
		-Dkst_release=$(usex debug OFF ON)
		-Dkst_rpath=OFF
		-Dkst_svnversion=OFF
		-Dkst_test=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
