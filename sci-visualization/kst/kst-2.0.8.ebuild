# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

MY_P=Kst-${PV}

DESCRIPTION="Fast real-time large-dataset viewing and plotting tool"
HOMEPAGE="https://kst.kde.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

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
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sci-libs/cfitsio
	sci-libs/getdata
	sci-libs/gsl
	sci-libs/netcdf-cxx:3
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS README.kstScript )

PATCHES=(
	"${FILESDIR}/${P}-includes.patch"
	"${FILESDIR}/${P}-qt-5.11.patch"
	"${FILESDIR}/${P}-gsl-2.0.patch"
)

src_configure() {
	local mycmakeargs=(
		-Dkst_install_libdir="$(get_libdir)"
		-Dkst_pch=OFF
		-Dkst_qt5=ON
		-Dkst_release=$(usex debug OFF ON)
		-Dkst_rpath=OFF
		-Dkst_svnversion=OFF
		-Dkst_test=$(usex test)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
