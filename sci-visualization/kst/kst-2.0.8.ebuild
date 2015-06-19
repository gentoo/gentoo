# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/kst/kst-2.0.8.ebuild,v 1.1 2015/04/10 15:23:54 pesa Exp $

EAPI=5

inherit cmake-utils multilib

MY_P=Kst-${PV}

DESCRIPTION="Fast real-time large-dataset viewing and plotting tool"
HOMEPAGE="http://kst.kde.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +qt4 qt5 test"

REQUIRED_USE="^^ ( qt4 qt5 )"

RESTRICT="test"

RDEPEND="
	qt4? (
		dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtsvg:4
	)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	sci-libs/cfitsio
	sci-libs/getdata
	sci-libs/gsl
	sci-libs/netcdf-cxx:3
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:4 )
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS README.kstScript )

src_configure() {
	local mycmakeargs=(
		-Dkst_install_libdir="$(get_libdir)"
		-Dkst_pch=OFF
		-Dkst_release=$(usex debug OFF ON)
		-Dkst_rpath=OFF
		-Dkst_svnversion=OFF
		$(cmake-utils_use test kst_test)
		$(cmake-utils_use qt5 kst_qt5)
	)
	cmake-utils_src_configure
}
