# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openmesh/openmesh-3.3.ebuild,v 1.1 2015/08/05 15:32:21 jsbronder Exp $

EAPI="5"
inherit eutils cmake-utils

MY_PN="OpenMesh"
MY_PV="${PV/_rc/-RC}"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="A generic and efficient data structure for representing and manipulating polygonal meshes"
HOMEPAGE="http://www.openmesh.org/"
SRC_URI="http://openmesh.org/media/Releases/${MY_PV/-RC/RC}/${MY_PN}-${MY_PV}.tar.bz2"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="qt4 qt5 static-libs test"

RDEPEND="
	qt4? ( dev-qt/qtgui:4
		dev-qt/qtopengl:4
		media-libs/freeglut )
	qt5? ( dev-qt/qtgui:5
		dev-qt/qtopengl:5
		media-libs/freeglut )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_prepare() {
	# Fix libdir and remove rpath.
	sed -i \
		-e "s|\(set (ACG_PROJECT_LIBDIR \"\).*|\1$(get_libdir)/\")|" \
		-e "s|\(set (ACG_PROJECT_PLUGINDIR \"\)lib\(.*\)|\1$(get_libdir)\2|" \
		-e "s|\(BUILD_WITH_INSTALL_RPATH \)1|\1 0|" \
		-e "s|\(SKIP_BUILD_RPATH\) 0|\1 1|" \
		-e '/^ *INSTALL_RPATH/d' \
		cmake/ACGCommon.cmake || die

	if ! use static-libs; then
		sed -i "s|\(SHARED\)ANDSTATIC|\1|" \
			src/${MY_PN}/{Core,Tools}/CMakeLists.txt || die
		sed -i '/OpenMeshCoreStatic/d' \
			src/${MY_PN}/Tools/CMakeLists.txt || die
	fi
}

src_configure() {
	mycmakeargs=""

	mycmakeargs="${mycmakeargs} -DOPENMESH_BUILD_UNIT_TESTS=TRUE"

	# Disable python bindings until someone wants them.
	mycmakeargs="${mycmakeargs} -DOPENMESH_BUILD_PYTHON_BINDINGS=FALSE"
	mycmakeargs="${mycmakeargs} -DOPENMESH_BUILD_PYTHON_UNIT_TESTS=FALSE"

	if ! use qt4 && ! use qt5; then
		mycmakeargs="${mycmakeargs} -DBUILD_APPS=OFF"
	fi

	if use qt4 && ! use qt5; then
		mycmakeargs="${mycmakeargs} -DFORCE_QT4=ON"
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc LICENSE/* README CHANGELOG
}
