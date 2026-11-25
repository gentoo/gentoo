# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
PYTHON_COMPAT=( python3_{10..14} )

LLVM_COMPAT=( 23 )

inherit cmake edob flag-o-matic multiprocessing llvm-r2 python-any-r1 rocm
DESCRIPTION="General matrix-matrix operations library for AMD Instinct accelerators"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblaslt"
MY_URI="https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}"
SRC_URI="
	${MY_URI}/hipblaslt.tar.gz -> hipblaslt-${PV}.tar.gz
	${MY_URI}/origami.tar.gz -> origami-${PV}.tar.gz
	${MY_URI}/stinkytofu.tar.gz -> stinkytofu-${PV}.tar.gz
	benchmark? ( ${MY_URI}/mxdatagenerator.tar.gz -> mxdatagenerator-${PV}.tar.gz )
	https://github.com/ROCm/rocm-libraries/commit/bf56af2e53b7ba22b4ac86e8d8cd25df8040b0f2.patch
		-> ${P}-true16.patch
"

# monorepo layout: hipBLASLt refers to ../../shared/{origami,stinkytofu,mxdatagenerator}
S="${WORKDIR}/projects/hipblaslt"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

SUPPORTED_GPUS=(
	gfx908 gfx90a gfx942 gfx950 gfx1100 gfx1101 gfx1102 gfx1103
	gfx1150 gfx1151 gfx1152 gfx1153 gfx1200 gfx1201
)
IUSE_TARGETS=( "${SUPPORTED_GPUS[@]/#/amdgpu_targets_}" )
IUSE="${IUSE_TARGETS[*]/#/+} benchmark roctracer test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	roctracer? ( dev-util/roctracer:${SLOT} )
	benchmark? (
		sci-libs/flexiblas
	)
"

DEPEND="
	${RDEPEND}
	dev-cpp/msgpack-cxx
	sci-libs/hipBLAS-common:${SLOT}
	llvm-runtimes/openmp
	test? ( dev-util/amdsmi:${SLOT} )
"

BDEPEND="
	${PYTHON_DEPS}
	dev-build/rocm-cmake:${SLOT}
	dev-util/hipcc:${SLOT}
	$(python_gen_any_dep "
		dev-python/msgpack[\${PYTHON_USEDEP}]
		dev-python/pyyaml[\${PYTHON_USEDEP}]
		dev-python/joblib[\${PYTHON_USEDEP}]
		dev-python/nanobind[\${PYTHON_USEDEP}]
		dev-python/setuptools[\${PYTHON_USEDEP}]
	")
	$(llvm_gen_dep "llvm-core/clang:\${LLVM_SLOT}")
	test? (
		dev-cpp/gtest
		sci-libs/flexiblas
	)
"

# Since 7.1.0 to build tests one needs to build benchmarks (which will be installed)
# TODO: make build of tests independent benchmarks
REQUIRED_USE="test? ( benchmark )"

PATCHES=(
	"${FILESDIR}"/${PN}-10.1.0-rocisa-nanobind.patch
)

python_check_deps() {
	python_has_version "dev-python/msgpack[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/joblib[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/nanobind[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	QA_FLAGS_IGNORED="usr/$(get_libdir)/hipblaslt/library/.*"
	python-any-r1_pkg_setup
}

pkg_pretend() {
	if [[ "${AMDGPU_TARGETS[*]}" = "" ]]; then
		ewarn "hipBLASLt supports only some GPUs: ${SUPPORTED_GPUS[*]},"
		ewarn "but none of them were defined in AMDGPU_TARGETS USE_EXPAND variable."
		ewarn
		ewarn "Library will continue to be built in \"dummy\" mode,"
		ewarn "serving as a non-functional placeholder for end-user applications."
	fi
}

src_unpack() {
	mkdir -p projects shared || die
	pushd projects >/dev/null || die
	unpack hipblaslt-${PV}.tar.gz
	popd >/dev/null || die
	pushd shared >/dev/null || die
	unpack origami-${PV}.tar.gz stinkytofu-${PV}.tar.gz
	use benchmark && unpack mxdatagenerator-${PV}.tar.gz
	popd >/dev/null || die
}

src_prepare() {
	# LLVM 23 rejects fake16 syntax on gfx11/gfx12; the patch spans projects/ and shared/
	pushd "${WORKDIR}" >/dev/null || die
	eapply "${DISTDIR}"/${P}-true16.patch
	popd >/dev/null || die

	local shebangs=($(grep -rl "#!/usr/bin/env python3" tensilelite/Tensile || die))
	python_fix_shebang -q "${shebangs[@]}"

	rocm_use_clang

	sed -e "s:\$(ROCM_PATH)/bin/amdclang++:$(get_llvm_prefix)/bin/clang++:g" \
		-i tensilelite/Makefile || die

	# Fix compiler validation (just a validation)
	sed -e "s/amdclang/$(basename "$CC")/g" \
		-i tensilelite/Tensile/Toolchain/Validators.py \
		-i tensilelite/Tensile/Tests/unit/test_MatrixInstructionConversion.py || die

	# Do not install tests
	sed -e "s/COMPONENT tests/COMPONENT tests EXCLUDE_FROM_ALL/" -i CMakeLists.txt || die

	# No -Werror
	sed -e "/set(STINKYTOFU_ENABLE_WERROR ON)/d" -i tensilelite/rocisa/CMakeLists.txt || die

	# libc++ does not include <iterator> and <cstdlib> transitively
	sed -e "/#include <map>/i #include <iterator>" \
		-i tensilelite/include/Tensile/{MasterSolutionLibrary,PlaceholderLibrary}.hpp || die
	sed -e "/#include <cxxabi.h>/a #include <cstdlib>" \
		-i tensilelite/rocisa/rocisa/src/helper.cpp || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class

	# rocisa asserts on comments inside macro bodies, upstream builds without asserts
	append-cppflags -DNDEBUG

	local targets="$(get_amdgpu_flags)"
	local Tensile_SKIP_BUILD=$([ "${AMDGPU_TARGETS[*]}" = "" ] && echo ON || echo OFF )
	local HIPBLASLT_ENABLE_DEVICE=$([ "${AMDGPU_TARGETS[*]}" != "" ] && echo ON || echo OFF )

	# targets has a trailing semicolon, this trips up Tensile's input parser, so carefully prune
	local mycmakeargs=(
		-DGPU_TARGETS="${targets%;}"
		-DHIPBLASLT_ENABLE_CLIENT="$(usex benchmark ON $(usex test ON OFF))"
		-DHIPBLASLT_ENABLE_SAMPLES=OFF
		-DHIPBLASLT_ENABLE_DEVICE=${HIPBLASLT_ENABLE_DEVICE}
		-DHIPBLASLT_ENABLE_MARKER="$(usex roctracer ON OFF)"
		-DHIPBLASLT_ENABLE_ROCROLLER=OFF
		-DHIPBLASLT_ENABLE_FETCH=OFF
		-DHIPBLASLT_BUNDLE_PYTHON_DEPS=ON
		-Dnanobind_DIR="$(python_get_sitedir)/nanobind/cmake"
		# use system nanobind and rocm-cmake instead of git clones
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
		-DPython_EXECUTABLE="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
		-DTENSILELITE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)
		-DHIPBLASLT_BUILD_TESTING="$(usex test ON OFF)"
		-DHIPBLASLT_ENABLE_AMD_SMI="$(usex test ON OFF)"
		-Wno-dev
	)

	if use test || use benchmark; then
		# HIPBLASLT_ENABLE_CLIENT=ON branch
		mycmakeargs+=(
			-DBLA_PKGCONFIG_BLAS=ON
			-DBLA_VENDOR=FlexiBLAS
			-DHIPBLASLT_ENABLE_BLIS=OFF
		)
	fi

	cmake_src_configure
}

src_compile() {
	local -x ROCM_PATH="${EPREFIX}/usr"
	# set PYTHONPATH to load Tensile from virtualenv, not the system-wide one
	local -x PYTHONPATH="${S}_build/virtualenv/lib/${EPYTHON}/site-packages"
	local -x TENSILE_ROCM_ASSEMBLER_PATH="$(get_llvm_prefix)/bin/clang++"
	# TensileCreateLibrary reads CMAKE_CXX_COMPILER again
	local -x CMAKE_CXX_COMPILER="$(get_llvm_prefix)/bin/clang++"
	cmake_src_compile
}

src_install() {
	cmake_src_install

	# Stop llvm-strip from removing .strtab section from *.hsaco files,
	# otherwise rocclr/elf/elf.cpp complains with "failed: null sections(STRTAB)" and crashes
	dostrip -x /usr/$(get_libdir)/hipblaslt/library/
}

src_test() {
	check_amdgpu

	# hipblaslt-test is added to CTest only within the rocm-libraries tree (shared/ctest);
	# run it like TheRock CI does (no filter). Expected time for 7900 XTX: 580s
	cd "${BUILD_DIR}"/clients || die
	# Fails in `MatrixTransformTest.MultipleDevices` in dGPU+iGPU combination
	local -x HIP_VISIBLE_DEVICES=0
	edob ./hipblaslt-test
}
