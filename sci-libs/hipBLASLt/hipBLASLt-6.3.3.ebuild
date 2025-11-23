# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
PYTHON_COMPAT=( python3_{10..13} )

LLVM_COMPAT=( 19 )

inherit cmake flag-o-matic llvm-r1 python-any-r1 rocm
DESCRIPTION="General matrix-matrix operations library for AMD Instinct accelerators"
HOMEPAGE="https://github.com/ROCm/hipBLASLt"
SRC_URI="https://github.com/ROCm/hipBLASLt/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hipBLASLt-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

SUPPORTED_GPUS=( gfx908 gfx90a gfx940 gfx941 gfx942 gfx1100 gfx1101 )
IUSE_TARGETS=( "${SUPPORTED_GPUS[@]/#/amdgpu_targets_}" )
IUSE="${IUSE_TARGETS[@]/#/+} test benchmark"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-cpp/msgpack-cxx
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/rocm-cmake
	sci-libs/hipBLAS-common:${SLOT}
	$(python_gen_any_dep '
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/joblib[${PYTHON_USEDEP}]
	')
	$(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}')
	test? (
		dev-cpp/gtest
		virtual/blas
		dev-util/rocm-smi:${SLOT}
	)
	benchmark? (
		virtual/blas
		llvm-runtimes/openmp
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-fix-msgpack-dependency.patch
	"${FILESDIR}"/${PN}-6.1.1-no-arch.patch
	"${FILESDIR}"/${PN}-6.1.1-no-git.patch
	"${FILESDIR}"/${PN}-6.1.1-clang-19.patch
	"${FILESDIR}"/${PN}-6.1.1-fix-libcxx.patch
	"${FILESDIR}"/${PN}-6.3.0-no-arch-extra.patch
	"${FILESDIR}"/${PN}-6.3.0-min-pip-install.patch
)

python_check_deps() {
	python_has_version "dev-python/msgpack[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/joblib[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

pkg_pretend() {
	if [[ "${AMDGPU_TARGETS[@]}" = "" ]]; then
		ewarn "hipBLASLt supports only few GPUs: ${SUPPORTED_GPUS[@]},"
		ewarn "but none of them were defined in AMDGPU_TARGETS USE_EXPAND variable."
		ewarn
		ewarn "Library will continue to be built in \"dummy\" mode,"
		ewarn "serving as a non-functional placeholder for end-user applications."
	fi
}

src_prepare() {
	sed -e "s,\@LLVM_PATH\@,$(get_llvm_prefix),g" \
		"${FILESDIR}"/${PN}-6.1.1-gentoopath.patch > "${S}"/gentoopath.patch || die
	eapply "${S}"/gentoopath.patch

	local shebangs=($(grep -rl "#!/usr/bin/env python3" tensilelite/Tensile || die))
	python_fix_shebang -q ${shebangs[*]}

	sed -e "s:\${rocm_path}/bin/amdclang++:$(get_llvm_prefix)/bin/clang++:" \
		-i library/src/amd_detail/rocblaslt/src/kernels/compile_code_object.sh || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_hipcc

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class

	local targets="$(get_amdgpu_flags)"
	local build_with_tensile=$([ "${AMDGPU_TARGETS[@]}" = "" ] && echo OFF || echo ON )

	local mycmakeargs=(
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_WITH_TENSILE="${build_with_tensile}"
		-DAMDGPU_TARGETS="${targets}"
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS="$(usex benchmark ON OFF)"
		-Wno-dev
	)

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
	cmake_src_test
}
