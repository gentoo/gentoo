# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
PYTHON_COMPAT=( python3_{10..14} )

LLVM_COMPAT=( 23 )

inherit cmake flag-o-matic multiprocessing llvm-r2 python-any-r1 rocm
DESCRIPTION="Sparse GEMM operations library for AMD Instinct accelerators"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsparselt"
MY_URI="https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}"
SRC_URI="
	${MY_URI}/hipsparselt.tar.gz -> hipsparselt-${PV}.tar.gz
	${MY_URI}/hipblaslt.tar.gz -> hipblaslt-${PV}.tar.gz
	${MY_URI}/origami.tar.gz -> origami-${PV}.tar.gz
	${MY_URI}/stinkytofu.tar.gz -> stinkytofu-${PV}.tar.gz
"

# monorepo layout: hipSPARSELt builds ../hipblaslt, which refers to ../../shared/{origami,stinkytofu}
S="${WORKDIR}/projects/hipsparselt"
HIPBLASLT_S="${WORKDIR}/projects/hipblaslt"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

# From hipsparselt_supported_architectures.cmake
SUPPORTED_GPUS=( gfx942 gfx950 )
IUSE_TARGETS=( "${SUPPORTED_GPUS[@]/#/amdgpu_targets_}" )
IUSE="${IUSE_TARGETS[*]/#/+} benchmark roctracer test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	roctracer? ( dev-util/roctracer:${SLOT} )
	benchmark? ( sci-libs/flexiblas )
"

DEPEND="
	${RDEPEND}
	dev-cpp/msgpack-cxx
	dev-libs/rocm-comgr:${SLOT}
	dev-libs/rocr-runtime:${SLOT}
	sci-libs/hipSPARSE:${SLOT}
	llvm-runtimes/openmp
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

python_check_deps() {
	python_has_version "dev-python/msgpack[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/joblib[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/nanobind[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	QA_FLAGS_IGNORED="usr/$(get_libdir)/hipsparselt/library/.*"
	python-any-r1_pkg_setup
}

pkg_pretend() {
	if [[ "${AMDGPU_TARGETS[*]}" = "" ]]; then
		ewarn "hipSPARSELt supports only some GPUs: ${SUPPORTED_GPUS[*]},"
		ewarn "but none of them were defined in AMDGPU_TARGETS USE_EXPAND variable."
		ewarn
		ewarn "Library will continue to be built in \"dummy\" mode,"
		ewarn "serving as a non-functional placeholder for end-user applications."
	fi
}

PATCHES=(
	"${FILESDIR}"/${P}-no-test-install.patch
)

src_unpack() {
	mkdir -p projects shared || die
	pushd projects >/dev/null || die
	unpack hipsparselt-${PV}.tar.gz hipblaslt-${PV}.tar.gz
	popd >/dev/null || die
	pushd shared >/dev/null || die
	unpack origami-${PV}.tar.gz stinkytofu-${PV}.tar.gz
	popd >/dev/null || die
}

src_prepare() {
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class

	pushd "${HIPBLASLT_S}" || die
	eapply "${FILESDIR}"/hipBLASLt-${PV}-rocisa-nanobind.patch

	# No -Werror
	sed -e "/set(STINKYTOFU_ENABLE_WERROR ON)/d" -i tensilelite/rocisa/CMakeLists.txt || die

	# libc++ does not include <iterator> and <cstdlib> transitively
	sed -e "/#include <map>/i #include <iterator>" \
		-i tensilelite/include/Tensile/{MasterSolutionLibrary,PlaceholderLibrary}.hpp || die
	sed -e "/#include <cxxabi.h>/a #include <cstdlib>" \
		-i tensilelite/rocisa/rocisa/src/helper.cpp || die
	sed -e '/#include "instruction.hpp"/a #include <iterator>' \
		-i tensilelite/rocisa/rocisa/include/instruction/cvt.hpp || die

	local shebangs=($(grep -rl "#!/usr/bin/env python3" tensilelite/Tensile || die))
	python_fix_shebang -q "${shebangs[@]}"

	# Fix compiler validation (just a validation)
	sed -e "s/amdclang/$(basename "$CC")/g" \
		-i tensilelite/Tensile/Toolchain/Validators.py || die
	sed -e "s:\$(ROCM_PATH)/bin/amdclang++:$(get_llvm_prefix)/bin/clang++:g" \
		-i tensilelite/Makefile || die
	popd || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	# rocisa asserts on comments inside macro bodies, upstream builds without asserts
	append-cppflags -DNDEBUG

	local targets="$(get_amdgpu_flags)"
	local HIPSPARSELT_ENABLE_DEVICE=$([ "${AMDGPU_TARGETS[*]}" != "" ] && echo ON || echo OFF )

	# targets has a trailing semicolon, this trips up Tensile's input parser, so carefully prune
	local mycmakeargs=(
		-DGPU_TARGETS="${targets%;}"
		-DHIPSPARSELT_ENABLE_SAMPLES=OFF
		-DHIPSPARSELT_ENABLE_DEVICE=${HIPSPARSELT_ENABLE_DEVICE}
		-DHIPSPARSELT_BUILD_TESTING="$(usex test ON OFF)"
		-DHIPSPARSELT_ENABLE_BENCHMARKS="$(usex benchmark ON OFF)"

		-DHIPSPARSELT_ENABLE_MARKER="$(usex roctracer ON OFF)"
		-Dnanobind_DIR="$(python_get_sitedir)/nanobind/cmake"
		# use system nanobind and rocm-cmake instead of git clones
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
		-DPython_EXECUTABLE="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
		-Wno-dev
	)

	if [[ "${AMDGPU_TARGETS[*]}" != "" ]]; then
		mycmakeargs+=(
			-DTENSILELITE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)
		)
	fi

	if use test || use benchmark; then
		mycmakeargs+=(
			-DHIPSPARSELT_ENABLE_CLIENT=ON
			-DBLA_VENDOR=FlexiBLAS
		)
	else
		mycmakeargs+=(
			-DHIPSPARSELT_ENABLE_CLIENT=OFF
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
	dostrip -x /usr/$(get_libdir)/hipsparselt/library/
}

src_test() {
	check_amdgpu
	# Non-instinct GPUs: tests just succeed without testing anything
	HIP_VISIBLE_DEVICES=0 cmake_src_test
}
