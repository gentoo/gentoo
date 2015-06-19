# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openmesh/openmesh-2.3.1.ebuild,v 1.3 2014/01/14 13:53:21 ago Exp $

EAPI="3"
inherit eutils cmake-utils

MY_PN="OpenMesh"
MY_PV="${PV/_rc/-RC}"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="A generic and efficient data structure for representing and manipulating polygonal meshes"
HOMEPAGE="http://www.openmesh.org/"
SRC_URI="http://openmesh.org/fileadmin/${PN}-files/${MY_PV/-RC/RC}/${MY_PN}-${MY_PV}.tar.bz2"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="qt4 static-libs"

RDEPEND="qt4? ( dev-qt/qtgui:4
	dev-qt/qtopengl:4
	media-libs/freeglut )"
DEPEND="${RDEPEND}"

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
	mycmakeargs="$(cmake-utils_use_build "qt4" "APPS")"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc LICENSE/* README CHANGELOG || die
}
