# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/OctoMap/octomap"
fi

inherit ${SCM} cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/OctoMap/octomap/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="An Efficient Probabilistic 3D Mapping Framework Based on Octrees"
HOMEPAGE="http://octomap.github.io/"
IUSE="qt4 dynamicEDT3D doc"
LICENSE="BSD qt4? ( GPL-2 )"
SLOT="0"

RDEPEND="
	qt4? (
		virtual/opengl
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		x11-libs/libQGLViewer:=
	)
"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
PATCHES=( "${FILESDIR}/gentoo.patch" )

src_prepare() {
	sed -e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/' \
		-i */CMakeLists.txt \
		-i */CMakeModules/InstallPkgConfigFile.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DBUILD_OCTOVIS_SUBPROJECT=$(usex qt4 ON OFF)"
		"-DBUILD_DYNAMICETD3D_SUBPROJECT=$(usex dynamicEDT3D ON OFF)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		cd "${BUILD_DIR}/octomap"
		emake docs
		if use dynamicEDT3D ; then
			cd "${BUILD_DIR}/dynamicEDT3D"
			emake docs_dynamicEDT3D
		fi
	fi
}

src_install() {
	cmake-utils_src_install
	if use doc ; then
		insinto /usr/share/doc/${PF}/html/octomap
		doins -r "${S}/octomap/doc/html/"*
		if use dynamicEDT3D ; then
			insinto /usr/share/doc/${PF}/html/dynamicEDT3D
			doins -r "${S}/dynamicEDT3D/doc/html/"*
		fi
	fi
}
