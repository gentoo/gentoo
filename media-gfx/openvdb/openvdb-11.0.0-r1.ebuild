# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
LLVM_OPTIONAL=1
LLVM_COMPAT=( 15 )

inherit cmake cuda flag-o-matic llvm-r2 multibuild python-single-r1 toolchain-funcs

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="
	https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/AcademySoftwareFoundation/openvdb/commit/930c3acb8e0c7c2f1373f3a70dc197f5d04dfe74.patch
	-> ${PN}-11.0.0-drop-obsolete-isActive-gcc15.patch
"

LICENSE="MPL-2.0"
OPENVDB_ABI=$(ver_cut 1)
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
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
	ax? ( ${LLVM_REQUIRED_USE} )
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
		$(llvm_gen_dep '
			llvm-core/llvm:${LLVM_SLOT}=
		')
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
			dev-util/nvidia-cuda-toolkit:=
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
		media-libs/libglvnd[X]
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

cuda_get_host_compiler() {
	if [[ -v NVCC_CCBIN ]]; then
		echo "${NVCC_CCBIN}"
		return
	fi

	if [[ -v CUDAHOSTCXX ]]; then
		echo "${CUDAHOSTCXX}"
		return
	fi

	einfo "Trying to find working CUDA host compiler"

	if ! tc-is-gcc && ! tc-is-clang; then
		die "$(tc-get-compiler-type) compiler is not supported (use gcc or clang)"
	fi

	local compiler compiler_type compiler_version
	local package package_version
	local NVCC_CCBIN_default

	compiler_type="$(tc-get-compiler-type)"
	compiler_version="$("${compiler_type}-major-version")"

	# try the default compiler first
	NVCC_CCBIN="$(tc-getCXX)"
	NVCC_CCBIN_default="${NVCC_CCBIN}-${compiler_version}"

	compiler="${NVCC_CCBIN/%-${compiler_version}}"

	# store the package so we can re-use it later
	package="sys-devel/${compiler_type}"
	package_version="${package}"

	ebegin "testing ${NVCC_CCBIN_default} (default)"

	while ! nvcc -v -ccbin "${NVCC_CCBIN}" - -x cu <<<"int main(){}" &>> "${T}/cuda_get_host_compiler.log" ; do
		eend 1

		while true; do
			# prepare next version
			if ! package_version="<$(best_version "${package_version}")"; then
				die "could not find a supported version of ${compiler}"
			fi

			NVCC_CCBIN="${compiler}-$(ver_cut 1 "${package_version/#<${package}-/}")"

			[[ "${NVCC_CCBIN}" != "${NVCC_CCBIN_default}" ]] && break
		done
		ebegin "testing ${NVCC_CCBIN}"
	done
	eend $?

	# clean temp file
	nonfatal rm -f a.out

	echo "${NVCC_CCBIN}"
	export NVCC_CCBIN

	einfo "Using ${NVCC_CCBIN} to build (via ${package} iteration)"
}

cuda_get_host_native_arch() {
	if [[ -n ${CUDAARCHS} ]]; then
		echo "${CUDAARCHS}"
		return
	fi

	if ! SANDBOX_WRITE=/dev/nvidiactl test -w /dev/nvidiactl ; then
		eerror
		eerror "Can not access the GPU at /dev/nvidiactl."
		eerror "User $(id -nu) is not in the group \"video\"."
		eerror
		ewarn
		ewarn "Can not query the native device. Not setting CUDAARCHS."
		ewarn "Continuing with default value. Set CUDAARCHS manually if needed."
		ewarn
		return 1
	fi

	__nvcc_device_query || eerror "failed to query the native device"
}

pkg_setup() {
	use ax && llvm-r2_pkg_setup
	use python && python-single-r1_pkg_setup

	if use cuda; then
		# sets up /dev files as a side-effect
		# needs to be run in pkg_setup as root
		nvidia-smi -L >/dev/null
	fi
}

src_prepare() {
	MULTIBUILD_VARIANTS=( install )
	use test && MULTIBUILD_VARIANTS+=( test )

	rm "cmake/Find"{OpenEXR,TBB}".cmake" || die

	if use nanovdb; then
		sed \
			-e 's#message(WARNING " - OpenVDB required to build#message(VERBOSE " - OpenVDB required to build#g' \
			-i "nanovdb/nanovdb/"*"/CMakeLists.txt" || die

		# backported gcc-15 fix #938253
		cp "${DISTDIR}/${PN}-11.0.0-drop-obsolete-isActive-gcc15.patch" "${T}" || die

		sed -e "s#nanovdb/nanovdb/tools/GridBuilder.h#nanovdb/nanovdb/util/GridBuilder.h#g" \
			-i "${T}/${PN}-11.0.0-drop-obsolete-isActive-gcc15.patch" || die

		eapply "${T}/${PN}-11.0.0-drop-obsolete-isActive-gcc15.patch"

		sed -e '24i #include <iomanip>' -i nanovdb/nanovdb/unittest/TestNanoVDB.cu || die
	fi

	cmake_src_prepare

	sed -e 's|/usr/local/bin/python|/usr/bin/python|' \
		-i "${S}"/openvdb/openvdb/python/test/TestOpenVDB.py || die
}

my_src_configure() {
	local version abi_version
	version=$(ver_cut 1)
	abi_version="${version}"
	if use "abi$(( version + 1 ))-compat"; then
		abi_version=$(( version + 1 ))
	elif use "abi$(( version - 1 ))-compat"; then
		abi_version=$(( version - 1 ))
	elif use "abi$(( version - 2 ))-compat"; then
		abi_version=$(( version - 2 ))
	fi

	local mycmakeargs=(
		-DCMAKE_FIND_PACKAGE_PREFER_CONFIG="yes"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"

		-DOPENVDB_ABI_VERSION_NUMBER="${abi_version}"
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
		-DUSE_CCACHE="no"
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
			addwrite "/proc/self/task/"
			addpredict "/dev/char"

			if [[ ! -v "${CUDAARCHS}" ]]; then
				local -x CUDAARCHS
				CUDAARCHS="$(cuda_get_host_native_arch)"
				einfo "Building with CUDAARCHS=${CUDAARCHS}"
			fi


			if [[ ! -v CUDAHOSTCXX ]]; then
				local -x CUDAHOSTCXX
				CUDAHOSTCXX="$(cuda_get_host_compiler)"
			fi
			if [[ ! -v CUDAHOSTLD ]]; then
				local -x CUDAHOSTLD
				CUDAHOSTLD="$(tc-getCXX)"
			fi


			if tc-is-gcc; then
				# Filter out IMPLICIT_LINK_DIRECTORIES picked up by CMAKE_DETERMINE_COMPILER_ABI(CUDA)
				# See /usr/share/cmake/Help/variable/CMAKE_LANG_IMPLICIT_LINK_DIRECTORIES.rst
				CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES_EXCLUDE=$(
					"${CUDAHOSTLD}" -E -v - <<<"int main(){}" |& \
					grep LIBRARY_PATH | cut -d '=' -f 2 | cut -d ':' -f 1
				)
			fi
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

	local -x GTEST_FILTER="!TestUtil.testCpuTimer"
	local -x CMAKE_SKIP_TESTS=(
		"^pytest$"
	)

	cmake_src_test
}

my_src_install() {
	[[ "${MULTIBUILD_VARIANT}" == "test" ]] && return
	cmake_src_install
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/926820
	# https://github.com/AcademySoftwareFoundation/openvdb/issues/1784
	append-flags -fno-strict-aliasing
	filter-lto

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
