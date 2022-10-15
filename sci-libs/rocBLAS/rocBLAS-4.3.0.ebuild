# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake multiprocessing prefix python-any-r1

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-${P}.tar.gz
	https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="benchmark test"
SLOT="0/$(ver_cut 1-2)"

BDEPEND="
	dev-util/rocm-cmake
	!dev-util/Tensile
	$(python_gen_any_dep '
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"

DEPEND="
	dev-util/hip:${SLOT}
	dev-libs/msgpack
	test? ( virtual/blas
		dev-cpp/gtest
		sys-libs/libomp )
	benchmark? ( virtual/blas
		sys-libs/libomp )
"
RESTRICT="!test? ( test )"

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/msgpack[${PYTHON_USEDEP}]"
}

S="${WORKDIR}"/${PN}-rocm-${PV}

PATCHES=("${FILESDIR}"/${PN}-4.3.0-fix-glibc-2.32-and-above.patch
	"${FILESDIR}"/${PN}-4.3.0-change-default-Tensile-library-dir.patch
	"${FILESDIR}"/${PN}-4.3.0-link-system-blas.patch
	"${FILESDIR}"/${PN}-4.3.0-remove-problematic-test-suites.patch )

src_prepare() {
	eapply_user

	pushd "${WORKDIR}"/Tensile-rocm-${PV} || die
	eapply "${FILESDIR}/Tensile-${PV}-hsaco-compile-specified-arch.patch" # backported from upstream, should remove after 4.3.0
	eapply "${FILESDIR}/Tensile-4.3.0-output-commands.patch"
	sed -e "/Number of parallel jobs to launch/s:default=-1:default=$(makeopts_jobs):" -i Tensile/TensileCreateLibrary.py || die
	popd || die

	# Fit for Gentoo FHS rule
	sed -e "/PREFIX rocblas/d" \
		-e "/<INSTALL_INTERFACE/s:include:include/rocblas:" \
		-e "s:rocblas/include:include/rocblas:" \
		-e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:${EPREFIX}/usr/$(get_libdir)/rocblas:" \
		-e "s:share/doc/rocBLAS:share/doc/${P}:" \
		-e "/rocm_install_symlink_subdir( rocblas )/d" -i library/src/CMakeLists.txt || die

	# Use setup.py to install Tensile rather than pip
	sed -r -e "/pip install/s:([^ \"\(]*python) -m pip install ([^ \"\)]*):\1 setup.py install --single-version-externally-managed --root / WORKING_DIRECTORY \2:g" -i cmake/virtualenv.cmake

	sed -e "s:,-rpath=.*\":\":" -i clients/CMakeLists.txt || die

	cmake_src_prepare
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
		-DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-rocm-${PV}"
		-DBUILD_WITH_TENSILE=ON
		-DBUILD_WITH_TENSILE_HOST=ON
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

check_rw_permission() {
	cmd="[ -r $1 ] && [ -w $1 ]"
	errormsg="${user} do not have read and write permissions on $1! \n Make sure ${user} is in render group and check the permissions."
	if has sandbox ${FEATURES}; then
		user=portage
		su portage -c "${cmd}" || die ${errormsg}
	else
		user=`whoami`
		${cmd} || die ${errormsg}
	fi
}

src_test() {
	# check permissions on /dev/kfd and /dev/dri/render*
	check_rw_permission /dev/kfd
	check_rw_permission /dev/dri/render*
	addwrite /dev/kfd
	addwrite /dev/dri/
	cd "${BUILD_DIR}/clients/staging" || die
	ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library" ./rocblas-test
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.so clients/librocblas_fortran_client.so
		dobin clients/staging/rocblas-bench
	fi
}
