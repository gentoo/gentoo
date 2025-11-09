# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
PYTHON_COMPAT=( python3_{10..14} )

LLVM_COMPAT=( 20 )

inherit cmake flag-o-matic multiprocessing llvm-r1 python-any-r1 rocm
DESCRIPTION="General matrix-matrix operations library for AMD Instinct accelerators"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblaslt"
SRC_URI="https://github.com/ROCm/rocm-libraries/archive/refs/tags/rocm-${PV}.tar.gz -> rocm-libraries-${PV}.tar.gz"

S="${WORKDIR}/rocm-libraries-rocm-${PV}/projects/hipblaslt/"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

SUPPORTED_GPUS=( gfx908 gfx90a gfx942 gfx950 gfx1100 gfx1101 gfx1103 gfx1150 gfx1151 gfx1200 gfx1201 )
IUSE_TARGETS=( "${SUPPORTED_GPUS[@]/#/amdgpu_targets_}" )
IUSE="${IUSE_TARGETS[*]/#/+} benchmark roctracer test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-util/rocm-smi:${SLOT}
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

# In 7.1.0 to build tests one needs to build benchmarks (which will be installed)
# TODO: make build of tests independent benchmarks
REQUIRED_USE="test? ( benchmark )"

PATCHES=(
	"${FILESDIR}"/${PN}-7.1.0-no-git.patch
	"${FILESDIR}"/hipBLASLt-7.1.0-rocisa-nanobind.patch
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
	local HIPBLASLT="rocm-libraries-rocm-${PV}/projects/hipblaslt"
	local ORIGAMI="rocm-libraries-rocm-${PV}/shared/origami"
	tar -xzf "${DISTDIR}/${A}" "${HIPBLASLT}" "${ORIGAMI}" -C "${WORKDIR}" || die
}

src_prepare() {
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

	# usage: DEPENDS PACKAGE A PACKAGE B, not DEPENDS PACKAGE A DEPENDS PACKAGE B
	# https://rocm.docs.amd.com/projects/ROCmCMakeBuildTools/en/docs-7.1.0/reference/ROCMInstallTargets.html#command:rocm_export_targets
	# Bug: https://bugs.gentoo.org/965873
	# Upstream bug: https://github.com/ROCm/rocm-libraries/issues/2556
	sed -e "s/DEPENDS PACKAGE \${hipblas_target}/PACKAGE \${hipblas_target}/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class

	# Tensile guesses weirdly how to compile things, ld.bfd won't work, so force lld
	append-cxxflags -DCMAKE_CXX_FLAGS="-fuse-ld=lld"

	local targets="$(get_amdgpu_flags)"
	local Tensile_SKIP_BUILD=$([ "${AMDGPU_TARGETS[*]}" = "" ] && echo ON || echo OFF )
	local HIPBLASLT_ENABLE_DEVICE=$([ "${AMDGPU_TARGETS[*]}" != "" ] && echo ON || echo OFF )

	# targets has a trailing semicolon, this trips up Tensile's input parser, so carefully prune
	local mycmakeargs=(
		-DGPU_TARGETS="${targets::-1}"
		-DHIPBLASLT_ENABLE_CLIENT="$(usex benchmark ON $(usex test ON OFF))"
		-DHIPBLASLT_ENABLE_SAMPLES=OFF
		-DHIPBLASLT_ENABLE_DEVICE=${HIPBLASLT_ENABLE_DEVICE}
		-DHIPBLASLT_ENABLE_MARKER="$(usex roctracer ON OFF)"
		-DHIPBLASLT_ENABLE_ROCROLLER=OFF
		-DHIPBLASLT_ENABLE_FETCH=OFF
		-DHIPBLASLT_BUNDLE_PYTHON_DEPS=ON
		-Dnanobind_DIR="$(python_get_sitedir)/nanobind/cmake"
		-DPython_EXECUTABLE="${PYTHON}"
		-DROCM_SYMLINK_LIBS=OFF
		-DTENSILELITE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)
		-DHIPBLASLT_BUILD_TESTING="$(usex test ON OFF)"
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

	# Expected time for 7900 XTX: 340s (full) or 5s with GTEST_FILTER='*quick*'
	# Fails in `MatrixTransformTest.MultipleDevices` in dGPU+iGPU combination
	HIP_VISIBLE_DEVICES=0 cmake_src_test
}
