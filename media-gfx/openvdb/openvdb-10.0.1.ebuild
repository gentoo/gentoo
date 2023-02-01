# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake cuda llvm python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/10.0.1"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+abi10-compat abi8-compat abi9-compat ax +blosc cpu_flags_x86_avx cpu_flags_x86_sse4_2
	cuda doc +nanovdb numpy python static-libs test utils"
RESTRICT="!test? ( test )"

REQUIRED_USE="^^ ( abi8-compat abi9-compat abi10-compat )
	cpu_flags_x86_avx? ( cpu_flags_x86_sse4_2 )
	cuda? ( nanovdb )
	numpy? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )"

# utils? media-gfx/alembic not yet keyworded on ppc64
RDEPEND="
	>=dev-cpp/tbb-2020.3:=
	dev-libs/boost:=
	dev-libs/jemalloc:=
	dev-libs/log4cplus:=
	>=dev-libs/imath-3.1.4-r2:=
	sys-libs/zlib:=
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	ax? ( <sys-devel/llvm-15:= )
	blosc? ( dev-libs/c-blosc:= )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-11 )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[numpy?,python?,${PYTHON_USEDEP}]
			numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
	utils? (
		media-libs/glfw
		media-libs/glu
		media-libs/libjpeg-turbo:=
		media-libs/libpng:=
		>=media-libs/openexr-3:=
		virtual/opengl
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? (
		dev-cpp/gtest
		dev-util/cppunit
	)
"

LLVM_MAX_SLOT=14

PATCHES=(
	"${FILESDIR}/${PN}-8.1.0-glfw-libdir.patch"
	"${FILESDIR}/${PN}-9.0.0-fix-atomic.patch"
	"${FILESDIR}/${PN}-10.0.1-fix-linking-of-vdb_tool-with-OpenEXR.patch"
	"${FILESDIR}/${PN}-10.0.1-drop-failing-tests.patch"
)

pkg_setup() {
	use ax && llvm_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use cuda; then
		cuda_add_sandbox -w
		cuda_src_prepare
	fi

	sed -e 's|/usr/local/bin/python|/usr/bin/python|' \
		-i "${S}"/openvdb/openvdb/python/test/TestOpenVDB.py || die
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	local version
	if use abi8-compat; then
		version=8
	elif use abi9-compat; then
		version=9
	elif use abi10-compat; then
		version=10
	else
		die "OpenVDB ABI version is not compatible"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"
		-DOPENVDB_ABI_VERSION_NUMBER="${version}"
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_BUILD_VDB_LOD=$(usex utils)
		-DOPENVDB_BUILD_VDB_RENDER=$(usex utils)
		-DOPENVDB_BUILD_VDB_TOOL=$(usex utils)
		-DOPENVDB_BUILD_VDB_VIEW=$(usex utils)
		-DOPENVDB_CORE_SHARED=ON
		-DOPENVDB_CORE_STATIC=$(usex static-libs)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_AX=$(usex ax)
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_CCACHE=OFF
		-DUSE_COLORED_OUTPUT=ON
		# OpenEXR is only needed by the vdb_render tool and defaults to OFF
		-DUSE_EXR=$(usex utils)
		-DUSE_IMATH_HALF=ON
		-DUSE_LOG4CPLUS=ON
		-DUSE_NANOVDB=$(usex nanovdb)
		-DUSE_PKGCONFIG=ON
		# PNG is only needed by the vdb_render tool and defaults to OFF
		-DUSE_PNG=$(usex utils)
		-DUSE_TBB=ON
		-DUSE_ZLIB=$(usex ax ON $(usex blosc))
	)

	if use abi9-compat; then
		mycmakeargs+=( -DOPENVDB_USE_DEPRECATED_ABI_9=ON )
	elif use abi8-compat; then
		mycmakeargs+=( -DOPENVDB_USE_DEPRECATED_ABI_8=ON )
	fi

	if use ax; then
		mycmakeargs+=(
			-DOPENVDB_AX_STATIC=$(usex static-libs)
			-DOPENVDB_BUILD_AX_UNITTESTS=OFF # FIXME: log4cplus init and other errors
			-DOPENVDB_BUILD_VDB_AX=$(usex utils)
		)
	fi

	if use nanovdb; then
		mycmakeargs+=(
			-DNANOVDB_BUILD_UNITTESTS=$(usex test)
			-DNANOVDB_USE_CUDA=$(usex cuda)
			-DNANOVDB_USE_OPENVDB=ON
		)
		if use cpu_flags_x86_avx || use cpu_flags_x86_sse4_2; then
			mycmakeargs+=( -DNANOVDB_USE_INTRINSICS=ON )
		fi
	fi

	if use python; then
		mycmakeargs+=(
			-DOPENVDB_BUILD_PYTHON_MODULE=ON
			-DUSE_NUMPY=$(usex numpy)
			-DOPENVDB_BUILD_PYTHON_UNITTESTS=$(usex test)
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_INCLUDE_DIR="$(python_get_includedir)"
		)
		use test && mycmakeargs+=( -DPython_EXECUTABLE=${PYTHON} )
	fi

	# options for the new vdb_tool binary
	if use utils; then
		mycmakeargs+=(
			-DBUILD_TEST=$(usex test)
			-DOPENVDB_BUILD_VDB_AX=$(usex ax)
			-DOPENVDB_TOOL_NANO_USE_BLOSC=$(usex nanovdb $(usex blosc) OFF)
			-DOPENVDB_TOOL_USE_ABC=OFF # media-gfx/alembic not yet keyworded on ppc64
			-DOPENVDB_TOOL_USE_EXR=ON
			-DOPENVDB_TOOL_USE_JPG=ON
			-DOPENVDB_TOOL_USE_NANO=$(usex nanovdb)
			-DOPENVDB_TOOL_USE_PNG=ON
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD=AVX )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD=SSE42 )
	fi

	cmake_src_configure
}
