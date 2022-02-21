# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="docs"
DOCS_DEPEND="media-gfx/graphviz"
inherit cmake docs prefix

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-${P}.tar.gz
	https://media.githubusercontent.com/media/littlewu2508/littlewu2508.github.io/main/gentoo-distfiles/${P}-Tensile-asm_full-navi22.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/rocm-cmake:${SLOT}
	dev-util/Tensile:${SLOT}
"

DEPEND="
	dev-util/hip:${SLOT}
	dev-libs/msgpack
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
	# allow acces to hardware
	addpredict /dev/kfd
	addpredict /dev/dri/
	addpredict /dev/random

	export PATH="${EPREFIX}/usr/lib/llvm/roc/bin:${PATH}"

	local mycmakeargs=(
		-DTensile_LOGIC="asm_full"
		-DTensile_COMPILER="hipcc"
		-DTensile_LIBRARY_FORMAT="msgpack"
		-DTensile_CODE_OBJECT_VERSION="V3"
		-DTensile_TEST_LOCAL_PATH="${EPREFIX}/usr/share/Tensile"
		-DTensile_ROOT="${EPREFIX}/usr/share/Tensile"
		-DBUILD_WITH_TENSILE=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_SKIP_RPATH=TRUE
		-DBUILD_TESTING=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
	)

	CXX="hipcc" cmake_src_configure

	# do not rerun cmake and the build process in src_install
	sed -e '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_compile() {
	docs_compile
	cmake_src_compile
}

check_rw_permission() {
	local cmd="[ -r $1 ] && [ -w $1 ]"
	local error=0 user
	if has sandbox ${FEATURES}; then
		user="portage"
		su portage -c "${cmd}" || error=1
	else
		user="$(whoami)"
		bash -c "${cmd}" || error=1
	fi
	if [[ "${error}" == 1 ]]; then
		die "${user} do not have read and write permissions on $1! \n Make sure ${user} is in render group and check the permissions."
	fi
}

src_test() {
	# check permissions on /dev/kfd and /dev/dri/render*
	check_rw_permission /dev/kfd
	check_rw_permission /dev/dri/render*
	addwrite /dev/kfd
	addwrite /dev/dri/
	cd "${BUILD_DIR}/clients/staging" || die
	ROCBLAS_TEST_TIMEOUT=3600 LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src" ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library" ./rocblas-test || die "Tests failed"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.so clients/librocblas_fortran_client.so
		dobin clients/staging/rocblas-bench
	fi
}
