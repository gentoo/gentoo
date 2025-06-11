# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO
# drop OPENVDB_SIMD
# split out nanovdb

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake cuda flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"

if [[ "${PV}" == *9999* ]] ; then
	LLVM_COMPAT=( 15 )
	inherit llvm-r2
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/${PN}.git"
else
	SRC_URI="
		https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="MPL-2.0"
OPENVDB_ABI=$(ver_cut 1)
SLOT="0/$(ver_cut 1-2)"

CPU_FEATURES_X86=(
	avx:avx
	sse4_2:sse4_2
)
CPU_FEATURES_ARM=(
	neon:neon
)
CPU_FEATURES=(
	"${CPU_FEATURES_X86[@]/#/cpu_flags_x86_}"
	"${CPU_FEATURES_ARM[@]/#/cpu_flags_arm_}"
)

IUSE="
	abi$((OPENVDB_ABI + 1))-compat
	+abi${OPENVDB_ABI}-compat
	abi$((OPENVDB_ABI - 1))-compat
	abi$((OPENVDB_ABI - 2))-compat

	${CPU_FEATURES[*]%:*}
	alembic +blosc cuda doc examples jpeg +nanovdb numpy openexr pdal png python static-libs test utils +zlib
"

if [[ "${PV}" == *9999* ]] ; then
IUSE+=" ax"
fi
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
	test? (
		nanovdb? (
			blosc
		)
	)
"

# OPTDEPEND=(
# 	dev-util/gcovr
# )

RDEPEND="
	>=dev-cpp/tbb-2020.3:=
	dev-libs/boost:=
	dev-libs/jemalloc:=
	blosc? (
		dev-libs/c-blosc:=
	)
	nanovdb? (
		cuda? (
			dev-util/nvidia-cuda-toolkit
		)
		python? ( ${PYTHON_DEPS}
			$(python_gen_cond_dep '
				dev-python/nanobind[${PYTHON_USEDEP}]
			')
		)
	)
	openexr? ( >=media-libs/openexr-3:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[numpy?,${PYTHON_USEDEP}]
			dev-python/nanobind[${PYTHON_USEDEP}]
			numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
	utils? (
		media-libs/glfw
		media-libs/glu
		alembic? ( media-gfx/alembic )
		jpeg? ( media-libs/libjpeg-turbo:= )
		pdal? ( sci-libs/pdal:= )
		png? ( media-libs/libpng:= )
		openexr? ( >=media-libs/openexr-3:= )
		media-libs/libglvnd[X]
	)
	zlib? (
		sys-libs/zlib:=
	)
"

if [[ "${PV}" == *9999* ]] ; then
RDEPEND+="
	ax? (
		$(llvm_gen_dep '
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
	!ax? (
		dev-libs/log4cplus:=
	)
"
else
	RDEPEND+="
		dev-libs/log4cplus:=
	"
fi

DEPEND="${RDEPEND}
	utils? (
		openexr? (
			dev-libs/imath:=
		)
	)
"
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

	"${FILESDIR}/${PN}-10.0.1-log4cplus-version.patch"

	"${FILESDIR}/${PN}-11.0.0-cmake_fixes.patch"

	"${FILESDIR}/${PN}-12.0.0-fix-linking-of-vdb_tool-with-OpenEXR.patch"
	"${FILESDIR}/${PN}-12.0.0-loosen-float-equality-tolerances.patch"
	"${FILESDIR}/${PN}-12.0.0-remove-c-style-casts.patch"
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

# We could default to all-major, all here
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
		ewarn "Can not query the native device."
		ewarn "Not setting CUDAARCHS."
		ewarn
		ewarn "Continuing with default value."
		ewarn "Set CUDAARCHS manually if needed."
		ewarn
		return 1
	fi

	__nvcc_device_query || eerror "failed to query the native device"
}

pkg_setup() {
	if [[ "${PV}" == *9999* ]] ; then
		use ax && llvm-r2_pkg_setup
	fi
	use python && python-single-r1_pkg_setup

	if use cuda; then
		# sets up /dev files as a side-effect
		# needs to be run in pkg_setup as root
		nvidia-smi -L >/dev/null
	fi
}

src_prepare() {
	# remove outdated
	rm "cmake/Find"{OpenEXR,TBB}".cmake" || die

	if use nanovdb; then
		sed \
			-e 's#message(WARNING " - OpenVDB required to build#message(VERBOSE " - OpenVDB required to build#g' \
			-i "nanovdb/nanovdb/"*"/CMakeLists.txt" || die
	fi

	# sed \
	# 	-e "/find_package(OpenGL/s#OpenGL#OpenGL COMPONENTS OpenGL GLX#g" \
	# 	-i openvdb_cmd/vdb_view/CMakeLists.txt || die

	sed \
		-e '/find_package(Boost/s/)/ CONFIG)/g' \
		-i \
			openvdb/openvdb/CMakeLists.txt \
			cmake/FindOpenVDB.cmake \
		|| die

	if use python; then
		python_fix_shebang openvdb/openvdb/python/test/TestOpenVDB.py
	fi

	cmake_src_prepare
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/926820
	# https://github.com/AcademySoftwareFoundation/openvdb/issues/1784
	append-flags -fno-strict-aliasing
	filter-lto

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
		# -DCMAKE_CXX_STANDARD="20"
		-DCMAKE_FIND_PACKAGE_PREFER_CONFIG="yes"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"

		-DOPENVDB_ABI_VERSION_NUMBER="${abi_version}"

		-DOPENVDB_BUILD_DOCS="$(usex doc)"
		# -DOPENVDB_BUILD_MAYA_PLUGIN="no"
		-DOPENVDB_BUILD_BINARIES="$(usex utils)"
		-DOPENVDB_BUILD_NANOVDB="$(usex nanovdb)"
		-DOPENVDB_BUILD_UNITTESTS="$(usex test)"

		-DOPENVDB_CORE_SHARED="yes"
		-DOPENVDB_CORE_STATIC="$(usex static-libs)"
		# -DOPENVDB_CXX_STRICT="yes"
		-DOPENVDB_ENABLE_UNINSTALL="no"
		-DOPENVDB_FUTURE_DEPRECATION="yes"
		# -DOPENVDB_USE_DELAYED_LOADING="yes"

		-DUSE_CCACHE="no"
		# -DUSE_COLORED_OUTPUT="no" # only adds the flag
		-DUSE_EXPLICIT_INSTANTIATION="no"

		# not packaged
		# -DOPENVDB_BUILD_HOUDINI_PLUGIN="no"
		# -DOPENVDB_BUILD_HOUDINI_ABITESTS="$(usex houdini "$(usex test)"))"

		# for nanovdb
		-DUSE_BLOSC="$(usex blosc)"
		-DUSE_TBB="yes"
		-DUSE_ZLIB="$(usex zlib)"

		"-DOPENVDB_USE_FUTURE_ABI_$(( version + 1 ))=$(usex "abi$(( version + 1 ))-compat")"
		"-DOPENVDB_USE_DEPRECATED_ABI_$(( version - 1 ))=$(usex "abi$(( version - 1 ))-compat")"
		"-DOPENVDB_USE_DEPRECATED_ABI_$(( version - 2 ))=$(usex "abi$(( version - 2 ))-compat")"
	)

	if [[ "${PV}" == *9999* ]] ; then
	mycmakeargs+=(
		-DOPENVDB_BUILD_AX="$(usex ax)"
		-DUSE_LOG4CPLUS="$(usex !ax)"
	)
	if use ax; then
	# NOTE Certain tests expect bit equality and don't set tolerance violating the C standard
	# 6.5 8)
	# A floating expression may be contracted, that is, evaluated as though it were an atomic operation,
	# thereby omitting rounding errors implied by the source code and the expression evaluation method.
	# The FP_CONTRACT pragma in <math.h> provides a way to disallow contracted expressions.
	# Otherwise, whether and how expressions are contracted is implementation-defined.
	#
	# To reproduce the upstream tests the testsuite is compiled separate with FP_CONTRACT=OFF
	# append-cflags   "-ffp-contract=off"
	# append-cxxflags "-ffp-contract=off"
		mycmakeargs+=(
			-DOPENVDB_AX_STATIC="$(usex static-libs)"
			# due to multibuild # TODO
			-DOPENVDB_AX_TEST_CMD="$(usex test)"
			-DOPENVDB_AX_TEST_CMD_DOWNLOADS="$(usex test)"
			-DOPENVDB_BUILD_AX_UNITTESTS="$(usex test)" # FIXME: log4cplus init and other errors
			-DOPENVDB_BUILD_VDB_AX="$(usex utils)"
			-DOPENVDB_DOXYGEN_AX="$(usex doc)"
		)
	fi
	else
	# stuck on llvm-15
	# #934813
	# https://github.com/AcademySoftwareFoundation/openvdb/issues/1804
	mycmakeargs+=(
		-DOPENVDB_BUILD_AX="no"
		-DUSE_LOG4CPLUS="yes"
	)
	fi

	if use doc; then
		mycmakeargs+=(
			-DOPENVDB_DOXYGEN_HOUDINI="no"
			-DOPENVDB_DOXYGEN_NANOVDB="$(usex nanovdb)"
			-DOPENVDB_DOXYGEN_INTERNAL="no"
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

			if [[ ! -v CUDAARCHS ]]; then
				local -x CUDAARCHS
				CUDAARCHS="$(cuda_get_host_native_arch)"
			fi
			einfo "Building with CUDAARCHS=${CUDAARCHS}"

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

		if use python; then
			if use test; then
				# we are building openvdb, so ensure the just build openvdb python bindings are used
				local -x PYTHONPATH="${BUILD_DIR}/openvdb/openvdb/python"
			fi
			mycmakeargs+=(
				-DNANOVDB_BUILD_PYTHON_MODULE="yes"
				-DNANOVDB_BUILD_PYTHON_UNITTESTS="$(usex test)"
			)
		fi
	fi

	if use python; then
		mycmakeargs+=(
			-DOPENVDB_BUILD_PYTHON_MODULE="yes"
			-DUSE_NUMPY="$(usex numpy)"
			-DVDB_PYTHON_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_INCLUDE_DIR="$(python_get_includedir)"
			-Dnanobind_DIR="$(python_get_sitedir)/nanobind/cmake"
		)
		if use test; then
			mycmakeargs+=(
				-DPython_EXECUTABLE="${PYTHON}"
				-DOPENVDB_BUILD_PYTHON_UNITTESTS="yes"
			)
		fi
	fi

	# options for the new vdb_tool binary
	if use utils; then
		mycmakeargs+=(
			-DOPENVDB_BUILD_VDB_LOD="yes"
			-DOPENVDB_BUILD_VDB_RENDER="yes"
			-DOPENVDB_BUILD_VDB_TOOL="yes"
			-DOPENVDB_BUILD_VDB_VIEW="yes"

			# vdb_tool
			-DOPENVDB_BUILD_VDB_TOOL_UNITTESTS="$(usex test)"

			-DOPENVDB_TOOL_USE_NANO="$(usex nanovdb)"
			-DOPENVDB_TOOL_NANO_USE_BLOSC="$(usex nanovdb "$(usex blosc)")"
			-DOPENVDB_TOOL_NANO_USE_ZIP="$(usex nanovdb "$(usex zlib)")"

			-DOPENVDB_TOOL_USE_ABC="$(usex alembic)"

			# only used by vdb_tool, defaults to OFF
			-DOPENVDB_TOOL_USE_EXR="$(usex openexr)"
			# only used by vdb_render, defaults to OFF
			-DUSE_EXR="$(usex openexr)"

			-DOPENVDB_TOOL_USE_JPG="$(usex jpeg)" # libjpeg-turbo
			-DOPENVDB_TOOL_USE_PDAL="$(usex pdal)"

			# only used by vdb_tool, defaults to OFF
			-DOPENVDB_TOOL_USE_PNG="$(usex png)" # libpng
			# only used by vdb_render, defaults to OFF
			-DUSE_PNG="$(usex png)"
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD="AVX" )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD="SSE42" )
	elif use cpu_flags_arm_neon; then
		# NOTE openvdb/openvdb/Platform.h -> /// SIMD Intrinsic Headers
		# arm_neon.h is only included when OPENVDB_USE_SSE42 or OPENVDB_USE_AVX are defined
		# The AVX and SSE42 is guarded by CMAKE_SYSTEM_PROCESSOR checks
		mycmakeargs+=( -DOPENVDB_SIMD="AVX" )
	fi

	cmake_src_configure
}

src_test() {
	if [[ "${PV}" == *9999* ]] ; then
	if use ax; then
		ln -sr "${CMAKE_USE_DIR}/openvdb_ax/openvdb_ax/test" "${BUILD_DIR}/test" || die
		local CMAKE_SKIP_TESTS=(
			"^vdb_ax_unit_test$"
		)
	fi
	fi

	if use cuda; then
		cuda_add_sandbox -w
		addwrite "/proc/self/task/"
		addpredict "/dev/char/"

		local -x GTEST_FILTER='-TestNanoVDBCUDA.CudaIndexGridToGrid_basic'
	fi

	local myctestargs=(
		--output-on-failure
	)

	cmake_src_test
}
