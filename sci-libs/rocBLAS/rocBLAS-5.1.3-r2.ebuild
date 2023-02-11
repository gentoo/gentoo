# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="media-gfx/graphviz"
ROCM_VERSION=${PV}
inherit cmake docs edo multiprocessing prefix rocm

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-${P}.tar.gz
	https://media.githubusercontent.com/media/littlewu2508/littlewu2508.github.io/main/gentoo-distfiles/${PN}-5.0.2-Tensile-asm_full-navi22.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/rocm-cmake:${SLOT}
	dev-util/Tensile:${SLOT}
"

DEPEND="
	dev-cpp/msgpack-cxx
	dev-util/hip
	test? (
		virtual/blas
		dev-cpp/gtest
		sys-libs/libomp
	)
	benchmark? (
		virtual/blas
		sys-libs/libomp
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.0-fix-glibc-2.32-and-above.patch
	"${FILESDIR}"/${PN}-5.0.2-change-default-Tensile-library-dir.patch
	"${FILESDIR}"/${PN}-5.0.2-cpp_lib_filesystem.patch
	"${FILESDIR}"/${PN}-5.0.2-unbundle-Tensile.patch
	)

src_prepare() {
	cmake_src_prepare
	cp -a "${WORKDIR}/asm_full/" library/src/blas3/Tensile/Logic/ || die
	# Fit for Gentoo FHS rule
	sed -e "/PREFIX rocblas/d" \
		-e "/<INSTALL_INTERFACE/s:include:include/rocblas:" \
		-e "s:rocblas/include:include/rocblas:" \
		-e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:${EPREFIX}/usr/$(get_libdir)/rocblas:" \
		-e "s:share/doc/rocBLAS:share/doc/${P}:" \
		-e "/rocm_install_symlink_subdir( rocblas )/d" -i library/src/CMakeLists.txt || die

	sed -e "s:,-rpath=.*\":\":" -i clients/CMakeLists.txt || die

	eprefixify library/src/tensile_host.cpp
}

src_configure() {
	addpredict /dev/random
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DTensile_LOGIC="asm_full"
		-DTensile_COMPILER="hipcc"
		-DTensile_LIBRARY_FORMAT="msgpack"
		-DTensile_CODE_OBJECT_VERSION="V3"
		-DTensile_TEST_LOCAL_PATH="${EPREFIX}/usr/share/Tensile"
		-DTensile_ROOT="${EPREFIX}/usr/share/Tensile"
		-DBUILD_WITH_TENSILE=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DBUILD_TESTING=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DTensile_CPU_THREADS=$(makeopts_jobs)
	)

	CXX=hipcc cmake_src_configure
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
	edob ./${PN,,}-test
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.so clients/librocblas_fortran_client.so
		dobin clients/staging/rocblas-bench
	fi
}
