# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

LLVM_MAX_SLOT=15

inherit cmake cuda flag-o-matic llvm multibuild python-single-r1 toolchain-funcs

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
OPENVDB_ABI=$(ver_cut 1)
SLOT="0/$PV"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="abi$((OPENVDB_ABI + 1))-compat +abi${OPENVDB_ABI}-compat abi$((OPENVDB_ABI - 1))-compat abi$((OPENVDB_ABI - 2))-compat alembic ax +blosc cpu_flags_x86_avx cpu_flags_x86_sse4_2
	cuda doc examples jpeg +nanovdb numpy openexr png python static-libs test utils zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	?? (
		abi$((OPENVDB_ABI + 1))-compat
		abi${OPENVDB_ABI}-compat
		abi$((OPENVDB_ABI - 1))-compat
		abi$((OPENVDB_ABI - 2))-compat
	)
	cpu_flags_x86_avx? ( cpu_flags_x86_sse4_2 )
	python? ( ${PYTHON_REQUIRED_USE} )
	blosc? ( zlib )
"

# OPTDEPEND=(
# 	dev-util/gcovr
# )

RDEPEND="
	>=dev-cpp/tbb-2020.3:=
	dev-libs/boost:=
	dev-libs/jemalloc:=
	dev-libs/imath:=
	ax? (
		<sys-devel/llvm-$(( LLVM_MAX_SLOT + 1 )):=
	)
	blosc? (
		dev-libs/c-blosc:=
		sys-libs/zlib:=
	)
	nanovdb? (
		zlib? (
			sys-libs/zlib:=
		)
		cuda? (
			>=dev-util/nvidia-cuda-toolkit-11
		)
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[numpy?,${PYTHON_USEDEP}]
			dev-python/pybind11[${PYTHON_USEDEP}]
			numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
	utils? (
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		media-libs/glfw
		media-libs/glu
		alembic? ( media-gfx/alembic )
		jpeg? ( media-libs/libjpeg-turbo:= )
		png? ( media-libs/libpng:= )
		openexr? ( >=media-libs/openexr-3:= )
		media-libs/libglvnd
	)
	!ax? (
		dev-libs/log4cplus:=
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
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

PATCHES=(
	"${FILESDIR}/${PN}-8.1.0-glfw-libdir.patch"

	"${FILESDIR}/${PN}-9.0.0-fix-atomic.patch"

	"${FILESDIR}/${PN}-10.0.1-fix-linking-of-vdb_tool-with-OpenEXR.patch"
	"${FILESDIR}/${PN}-10.0.1-log4cplus-version.patch"

	"${FILESDIR}/${PN}-11.0.0-constexpr-version.patch"
	"${FILESDIR}/${PN}-11.0.0-cmake_fixes.patch"
)

cuda_set_CUDAHOSTCXX() {
	local compiler
	tc-is-gcc && compiler="gcc"
	tc-is-clang && compiler="clang"
	[[ -z "$compiler" ]] && die "no compiler specified"

	local package="sys-devel/${compiler}"
	local version="${package}"
	local CUDAHOSTCXX_test
	while
		CUDAHOSTCXX="${CUDAHOSTCXX_test}"
		version=$(best_version "${version}")
		if [[ -z "${version}" ]]; then
			if [[ -z "${CUDAHOSTCXX}" ]]; then
				die "could not find supported version of ${package}"
			fi
			break
		fi
		CUDAHOSTCXX_test="$(
			dirname "$(
				realpath "$(
					which "${compiler}-$(echo "${version}" | grep -oP "(?<=${package}-)[0-9]*")"
				)"
			)"
		)"
		version="<${version}"
	do ! echo "int main(){}" | nvcc "-ccbin ${CUDAHOSTCXX_test}" - -x cu &>/dev/null; done

	export CUDAHOSTCXX
}

cuda_get_host_arch() {
	[[ -z "${CUDAARCHS}" ]] && einfo "trying to determine host CUDAARCHS"
	: "${CUDAARCHS:=$(__nvcc_device_query)}"
	einfo "building for CUDAARCHS = ${CUDAARCHS}"

	export CUDAARCHS
}

pkg_setup() {
	use ax && llvm_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	MULTIBUILD_VARIANTS=( install )
	use test && MULTIBUILD_VARIANTS+=( test )

	rm "cmake/Find"{OpenEXR,TBB}".cmake" || die

	if use nanovdb; then
		sed \
			-e 's#message(WARNING " - OpenVDB required to build#message(VERBOSE " - OpenVDB required to build#g' \
			-i "nanovdb/nanovdb/"*"/CMakeLists.txt" || die
	fi

	cmake_src_prepare

	sed -e 's|/usr/local/bin/python|/usr/bin/python|' \
		-i "${S}"/openvdb/openvdb/python/test/TestOpenVDB.py || die
}

my_src_configure() {
	local version
	version=$(ver_cut 1)
	if use "abi$(( version + 1 ))-compat"; then
		version=$(( version + 1 ))
	elif use "abi$(( version - 1 ))-compat"; then
		version=$(( version - 1 ))
	elif use "abi$(( version - 2 ))-compat"; then
		version=$(( version - 2 ))
	fi

	local mycmakeargs=(
		-DCMAKE_FIND_PACKAGE_PREFER_CONFIG="yes"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"

		-DOPENVDB_ABI_VERSION_NUMBER="${version}"
		-DOPENVDB_BUILD_DOCS="$(usex doc)"
		-DOPENVDB_BUILD_UNITTESTS="$(usex test)"
		-DOPENVDB_BUILD_VDB_LOD="$(usex utils)"
		-DOPENVDB_BUILD_VDB_RENDER="$(usex utils)"
		-DOPENVDB_BUILD_VDB_TOOL="$(usex utils)"
		-DOPENVDB_BUILD_VDB_VIEW="$(usex utils)"
		-DOPENVDB_CORE_SHARED="yes"
		-DOPENVDB_CORE_STATIC="$(usex static-libs)"
		# -DOPENVDB_CXX_STRICT="yes"
		-DOPENVDB_ENABLE_UNINSTALL="no"

		-DUSE_AX="$(usex ax)"

		-DOPENVDB_BUILD_HOUDINI_PLUGIN="no"
		# -DOPENVDB_DOXYGEN_HOUDINI="no"

		-DUSE_BLOSC="$(usex blosc)"
		# -DUSE_CCACHE="no"
		-DUSE_COLORED_OUTPUT="yes"
		# OpenEXR is only needed by the vdb_render tool and defaults to OFF
		-DUSE_EXR="$(usex openexr "$(usex utils)")"
		# not packaged
		-DUSE_HOUDINI="no"
		 # replaces openexr half
		-DUSE_IMATH_HALF="yes"
		-DUSE_LOG4CPLUS="$(usex !ax)"
		-DUSE_PKGCONFIG="yes"
		# PNG is only needed by the vdb_render tool and defaults to OFF
		-DUSE_PNG="$(usex png "$(usex utils)")"
		-DUSE_TBB="yes"
		-DUSE_ZLIB="$(usex zlib)"

		"-DOPENVDB_USE_FUTURE_ABI_$(( version + 1 ))=$(usex "abi$(( version + 1 ))-compat")"
		"-DOPENVDB_USE_DEPRECATED_ABI_$(( version - 1 ))=$(usex "abi$(( version - 1 ))-compat")"
		"-DOPENVDB_USE_DEPRECATED_ABI_$(( version - 2 ))=$(usex "abi$(( version - 2 ))-compat")"
	)

	if use ax; then
		mycmakeargs+=(
			-DOPENVDB_AX_STATIC="$(usex static-libs)"
			-DOPENVDB_DOXYGEN_AX="$(usex doc)"
			# due to multibuild
			# -DOPENVDB_AX_TEST_CMD="$(usex test)"
			# -DOPENVDB_AX_TEST_CMD_DOWNLOADS="$(usex test)"
			-DOPENVDB_BUILD_AX_UNITTESTS="$(usex test)" # FIXME: log4cplus init and other errors
			-DOPENVDB_BUILD_VDB_AX="$(usex utils)"
		)
	fi

	if use nanovdb; then
		mycmakeargs+=(
			-DUSE_NANOVDB="yes"
			# NOTE intentional so it breaks in sandbox if files are missing
			-DNANOVDB_ALLOW_FETCHCONTENT="yes"
			-DNANOVDB_BUILD_EXAMPLES="$(usex examples)"
			-DNANOVDB_BUILD_TOOLS="$(usex utils)"
			-DNANOVDB_BUILD_UNITTESTS="$(usex test)"
			-DNANOVDB_USE_BLOSC="$(usex blosc)"
			-DNANOVDB_USE_CUDA="$(usex cuda)"
			-DNANOVDB_USE_ZLIB="$(usex zlib)"

			# TODO add openvdb use flag or split nanovdb as they can be build independent of each other
			-DNANOVDB_USE_OPENVDB="yes"
		)
		if use cpu_flags_x86_avx || use cpu_flags_x86_sse4_2; then
			mycmakeargs+=(
				-DNANOVDB_USE_INTRINSICS="yes"
			)
		fi

		if use cuda; then
			cuda_add_sandbox -w
			cuda_set_CUDAHOSTCXX
			cuda_get_host_arch

			# NOTE tbb includes immintrin.h, which breaks nvcc so we pretend they are already included
			export CUDAFLAGS="-D_AVX512BF16VLINTRIN_H_INCLUDED -D_AVX512BF16INTRIN_H_INCLUDED"
		fi

		if use utils; then
			mycmakeargs+=(
				-DOPENVDB_TOOL_USE_NANO="yes"
				-DOPENVDB_TOOL_NANO_USE_BLOSC="$(usex blosc)"
				-DOPENVDB_TOOL_NANO_USE_ZIP="$(usex zlib)"
			)
		fi
	fi

	if use python; then
		mycmakeargs+=(
			-DOPENVDB_BUILD_PYTHON_MODULE="yes"
			-DUSE_NUMPY="$(usex numpy)"
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_INCLUDE_DIR="$(python_get_includedir)"
		)
		use test && mycmakeargs+=(
			-DPython_EXECUTABLE="${PYTHON}"
			-DOPENVDB_BUILD_PYTHON_UNITTESTS="yes"
		)
	fi

	# options for the new vdb_tool binary
	if use utils; then
		mycmakeargs+=(
			-DBUILD_TEST="$(usex test)"
			-DOPENVDB_BUILD_VDB_AX="$(usex ax)"

			-DOPENVDB_TOOL_USE_ABC="$(usex alembic)" # Alembic
			-DOPENVDB_TOOL_USE_EXR="$(usex openexr)" # OpenEXR
			-DOPENVDB_TOOL_USE_JPG="$(usex jpeg)" # libjpeg-turbo
			-DOPENVDB_TOOL_USE_PNG="$(usex png)" # libpng
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD="AVX" )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD="SSE42" )
	fi

	if [[ "${MULTIBUILD_VARIANT}" == "test" ]]; then
		# NOTE Certain tests expect bit equality and don't set tolerance violating the C standard
		# 6.5 8)
		# A floating expression may be contracted, that is, evaluated as though it were an atomic operation,
		# thereby omitting rounding errors implied by the source code and the expression evaluation method.
		# The FP_CONTRACT pragma in <math.h> provides a way to disallow contracted expressions.
		# Otherwise, whether and how expressions are contracted is implementation-defined.
		#
		# To reproduce the upstream tests the testsuite is compiled separate with FP_CONTRACT=OFF
		append-cflags   "-ffp-contract=off"
		append-cxxflags "-ffp-contract=off"
		if use ax; then
			mycmakeargs+=(
				-DOPENVDB_AX_TEST_CMD="yes"
				-DOPENVDB_AX_TEST_CMD_DOWNLOADS="yes"
			)
		fi
	fi

	cmake_src_configure
}

my_src_test() {
	[[ "${MULTIBUILD_VARIANT}" != "test" ]] && return

	if use ax; then
		ln -sr "${CMAKE_USE_DIR}/openvdb_ax/openvdb_ax/test" "${BUILD_DIR}/test" || die
	fi

	if use cuda; then
		cuda_add_sandbox -w
	fi

	cmake_src_test
}

my_src_install() {
	[[ "${MULTIBUILD_VARIANT}" == "test" ]] && return
	cmake_src_install
}

src_configure() {
	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	multibuild_foreach_variant my_src_test
}

src_install() {
	multibuild_foreach_variant my_src_install
}
