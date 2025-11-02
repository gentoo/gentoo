# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="docs/doxygen"
DOCS_DEPEND="media-gfx/graphviz"
LLVM_COMPAT=( 20 )
ROCM_VERSION=${PV}

inherit cmake docs edo flag-o-matic multiprocessing rocm llvm-r1

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocblas"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ROCm/rocm-libraries.git"
	EGIT_BRANCH="develop"
	S="${WORKDIR}/${P}/projects/rocblas"
	SLOT="0/7.0"
else
	SRC_URI="https://github.com/ROCm/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-${P}.tar.gz"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SLOT="0/$(ver_cut 1-2)"
	KEYWORDS="~amd64"
fi

LICENSE="MIT BSD"
IUSE="benchmark hipblaslt roctracer test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

BDEPEND="
	dev-build/rocm-cmake:${SLOT}
"

RDEPEND="
	dev-util/hip:${SLOT}
	roctracer? ( dev-util/roctracer:${SLOT} )
	hipblaslt? ( sci-libs/hipBLASLt:${SLOT} )
	benchmark? (
		dev-cpp/gtest
		llvm-runtimes/openmp
		sci-libs/flexiblas
	)
"

DEPEND="
	${RDEPEND}
	>=dev-cpp/msgpack-cxx-6.0.0
	test? (
		dev-cpp/gtest
		llvm-runtimes/openmp
		sci-libs/flexiblas
	)
	dev-util/Tensile:${SLOT}
"

QA_FLAGS_IGNORED="/usr/lib64/rocblas/library/.*"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.2-add-missing-header.patch
	"${FILESDIR}"/${PN}-7.0.2-expand-isa-compatibility.patch
	"${FILESDIR}"/${PN}-6.3.0-no-git.patch
)

src_prepare() {
	cmake_src_prepare

	# Remove RPATH's, fixes multilib compatibility
	sed -e "/apply_omp_settings/a return()" -i clients/CMakeLists.txt || die

	# Disable automagic linking with roctracer
	sed -e "s/if(ROCTRACER_INCLUDE_DIR/if(ROCBLAS_ENABLE_MARKER AND ROCTRACER_INCLUDE_DIR/" \
		-i library/CMakeLists.txt || die
}

src_configure() {
	llvm_prepend_path "${LLVM_SLOT}"
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class -Wno-unused-value

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DROCM_SYMLINK_LIBS=OFF
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_WITH_TENSILE=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS="$(usex test ON OFF)"
		-DBUILD_CLIENTS_BENCHMARKS="$(usex benchmark ON OFF)"
		-DBUILD_WITH_PIP=OFF
		-DBUILD_WITH_HIPBLASLT="$(usex hipblaslt ON OFF)"
		-DROCBLAS_ENABLE_MARKER="$(usex roctracer ON OFF)"
		-DLINK_BLIS=OFF
		-DTensile_COMPILER="${CXX}"
		-DTensile_ROOT="${EPREFIX}/usr/share/Tensile"
		-DTensile_CPU_THREADS="$(makeopts_jobs)"
		-Wno-dev
	)

	if use benchmark || use test; then
		mycmakeargs+=(
			-DBLA_PKGCONFIG_BLAS=ON
			-DBLA_VENDOR=FlexiBLAS
		)
	fi

	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/clients/staging || die
	export ROCBLAS_TEST_TIMEOUT=3600 ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library"
	export LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src"

	# `--gtest_filter=*quick*:*pre_checkin*-*known_bug*` is >1h on 7900XTX
	edob ./rocblas-test --yaml rocblas_smoke.yaml
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.a clients/librocblas_fortran_client.a
		dobin clients/staging/rocblas-bench
	fi

	# Stop llvm-strip from removing .strtab section from *.hsaco files,
	# otherwise rocclr/elf/elf.cpp complains with "failed: null sections(STRTAB)" and crashes
	dostrip -x "/usr/$(get_libdir)/rocblas/library/"
}
