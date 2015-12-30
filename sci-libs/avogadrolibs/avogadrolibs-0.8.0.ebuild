# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="http://www.openchemistry.org/"
SRC_URI="mirror://sourceforge/project/avogadro/avogadro2/${PV}/${P}.tar.bz2"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc opengl qt5 static-plugins test vtk"

REQUIRED_USE="qt5? ( opengl )"

RDEPEND="
	>=sci-chemistry/molequeue-0.7
	sci-libs/chemkit
	sci-libs/hdf5:=
	opengl? (
		dev-qt/qtopengl:5
		media-libs/glew
		)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		)
	vtk? ( sci-libs/vtk )
"
DEPEND="${DEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )"

PATCHES=( "${FILESDIR}"/${PN}-0.7.2-6464.patch "${FILESDIR}/"${P}-underlinking.patch )

src_configure() {
	local mycmakeargs=(
		-DUSE_PROTOCALL=OFF
		-DBUILD_GPL_PLUGINS=ON
		-DUSE_MOLEQUEUE=ON
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_use opengl OPENGL)
		$(cmake-utils_use_use qt5 QT)
		$(cmake-utils_use_build static-plugins STATIC_PLUGINS)
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use_use vtk VTK)
		)
	cmake-utils_src_configure
}
