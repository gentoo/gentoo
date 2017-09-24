# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils multilib

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
	test? ( dev-qt/qttest:5 )
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS README.kstScript )
PATCHES=( "${FILESDIR}/${P}-includes.patch" )

src_configure() {
	local mycmakeargs=(
		-Dkst_install_libdir="$(get_libdir)"
		-Dkst_pch=OFF
		-Dkst_qt5=ON
		-Dkst_release=$(usex debug OFF ON)
		-Dkst_rpath=OFF
		-Dkst_svnversion=OFF
		$(cmake-utils_use test kst_test)
	)

	cmake-utils_src_configure
}
