# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
PYTHON_COMPAT=( python3_{10..14} )

LLVM_COMPAT=( 22 )

inherit cmake flag-o-matic multiprocessing llvm-r2 python-any-r1 rocm
DESCRIPTION="Sparse GEMM operations library for AMD Instinct accelerators"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsparselt"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/rocm-${PV}/hipsparselt.tar.gz -> hipsparselt-${PV}.tar.gz
	https://github.com/ROCm/rocm-libraries/releases/download/rocm-${PV}/origami.tar.gz -> origami-${PV}.tar.gz
	https://github.com/ROCm/rocm-libraries/releases/download/rocm-${PV}/hipblaslt.tar.gz -> hipblaslt-${PV}.tar.gz
"

S="${WORKDIR}/hipsparselt"
ORIGAMI_S="${WORKDIR}/origami"
HIPBLASLT_S="${WORKDIR}/hipblaslt"

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
	dev-util/rocm-smi:${SLOT}
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

src_prepare() {
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class

	# Do not install tests
	sed -e 's/COMPONENT "tests"/COMPONENT "tests" EXCLUDE_FROM_ALL/' \
		-i CMakeLists.txt || die

	pushd "${HIPBLASLT_S}" || die
	eapply "${FILESDIR}"/hipBLASLt-7.1.0-rocisa-nanobind.patch

	sed -e 's:../../shared/origami:../origami:' -i CMakeLists.txt || die

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

	# Tensile guesses weirdly how to compile things, ld.bfd won't work, so force lld
	append-cxxflags -DCMAKE_CXX_FLAGS="-fuse-ld=lld"

	local targets="$(get_amdgpu_flags)"
	local HIPSPARSELT_ENABLE_DEVICE=$([ "${AMDGPU_TARGETS[*]}" != "" ] && echo ON || echo OFF )

	# targets has a trailing semicolon, this trips up Tensile's input parser, so carefully prune
	local mycmakeargs=(
		-DGPU_TARGETS="${targets::-1}"
		-DHIPSPARSELT_ENABLE_SAMPLES=OFF
		-DHIPSPARSELT_ENABLE_DEVICE=${HIPSPARSELT_ENABLE_DEVICE}
		-DHIPSPARSELT_BUILD_TESTING="$(usex test ON OFF)"
		-DHIPSPARSELT_ENABLE_BENCHMARKS="$(usex benchmark ON OFF)"

		-DHIPSPARSELT_ENABLE_MARKER="$(usex roctracer ON OFF)"
		-Dnanobind_DIR="$(python_get_sitedir)/nanobind/cmake"
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
