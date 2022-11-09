# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="An Efficient Probabilistic 3D Mapping Framework Based on Octrees"
HOMEPAGE="http://octomap.github.io/"
SRC_URI="https://github.com/OctoMap/octomap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD qt5? ( GPL-2 )"
SLOT="0/19"
KEYWORDS="~amd64 ~arm"
IUSE="qt5 dynamicEDT3D doc"

RDEPEND="
	qt5? (
		virtual/opengl
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		x11-libs/libQGLViewer:=
	)
"
BDEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"

src_prepare() {
	rm -r octovis/src/extern

	sed --in-place \
		--expression='s/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/' \
		*/CMakeLists.txt */CMakeModules/InstallPkgConfigFile.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DBUILD_OCTOVIS_SUBPROJECT=$(usex qt5 ON OFF)"
		"-DOCTOVIS_QT5=ON"
		"-DBUILD_DYNAMICETD3D_SUBPROJECT=$(usex dynamicEDT3D ON OFF)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build docs docs_dynamicEDT3D
}

src_install() {
	cmake_src_install

	if use doc; then
		docinto html/octomap
		dodoc -r octomap/doc/html/*

		docinto html/dynamicEDT3D
		dodoc -r dynamicEDT3D/doc/html/*
	fi

	insinto /usr/share/ros_packages/${PN}
	doins "${ED}/usr/share/${PN}/package.xml"

	if use qt5; then
		insinto /usr/share/ros_packages/octovis
		doins "${ED}/usr/share/octovis/package.xml"
	fi
}

src_test() {
	# override parallel mode only for tests
	local myctestargs=( "-j 1" )
	cmake_src_test
}
