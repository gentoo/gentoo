# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A library for storing voxel data"
HOMEPAGE="http://opensource.imageworks.com/?p=field3d"
SRC_COMMIT="b0ff0cd67893a4cbfa322676eb3eef10100d904d"
SRC_URI="https://github.com/imageworks/Field3D/archive/${SRC_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="doc mpi test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/imath-3.1.4-r2:=
	>=media-libs/openexr-3:0=
	sci-libs/hdf5:=
	doc? ( app-text/doxygen )
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.2-openexr-3-imath.patch"
	"${FILESDIR}/${PN}-1.7.2-boost-1.83-timer-header-deprecated.patch"
)

S="${WORKDIR}/${PN}-${SRC_COMMIT}"

src_prepare() {
	sed -e "s#auto_ptr#unique_ptr#g" -i include/*.h || die
	sed \
		-e "s#DESTINATION \${CMAKE_INSTALL_PREFIX}#DESTINATION \${CMAKE_INSTALL_DOCDIR}#" \
		-e "s#CMAKE_MINIMUM_REQUIRED( VERSION 2.8 )#CMAKE_MINIMUM_REQUIRED( VERSION 3.5 )#" \
		-i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Needed for now ("fix" compatibility with >=sci-libs/hdf5-1.12)
	# bug #808731
	append-cppflags -DH5_USE_110_API

	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=11

		-DINSTALL_DOCS="$(usex doc)" # Docs are not finished yet.
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen="$(usex !doc)"

		"$(cmake_use_find_package mpi MPI)"
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./unitTest || die
}
