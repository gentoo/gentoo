# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN="OpenMesh"
MY_PV="${PV/_rc/-RC}"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

DESCRIPTION="A generic data structure to represent and manipulate polygonal meshes"
HOMEPAGE="https://www.openmesh.org/"
SRC_URI="https://openmesh.org/media/Releases/${MY_PV/-RC/RC}/${MY_PN}-${MY_PV}.tar.bz2"

LICENSE="BSD"
SLOT="4"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="qt5 static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
		media-libs/freeglut
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	cmake-utils_src_prepare

	# Fix libdir and remove rpath.
	sed -i \
		-e "s|\(set (ACG_PROJECT_LIBDIR \"\).*|\1$(get_libdir)/\")|" \
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
	local mycmakeargs=(
		-DBUILD_APPS=$(usex qt5)
		-DOPENMESH_BUILD_UNIT_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${BUILD_DIR}/Build/$(get_libdir) ctest --verbose
}
