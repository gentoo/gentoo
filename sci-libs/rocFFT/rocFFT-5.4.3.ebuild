# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
ROCM_VERSION=${PV}

inherit cmake check-reqs edo multiprocessing python-r1 rocm

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocFFT.git"
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> rocFFT-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

# RDEPEND: perfscripts?  # currently masked by arch/amd64/x32/package.mask
RDEPEND="
perfscripts? (
	>=media-gfx/asymptote-2.61
	dev-texlive/texlive-latex
	dev-tex/latexmk
	sys-apps/texinfo
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}] )
${PYTHON_DEPS}"

CLIENT_DEPEND="
	dev-cpp/gtest
	dev-libs/boost
	>=sci-libs/fftw-3
	sys-libs/libomp
	sci-libs/rocRAND:${SLOT}[${ROCM_USEDEP}]
"
DEPEND="dev-util/hip
	test? (${CLIENT_DEPEND})
	benchmark? (${CLIENT_DEPEND})
	${PYTHON_DEPS}"

BDEPEND="
	>=dev-util/cmake-3.22
	dev-util/rocm-cmake
"

CHECKREQS_DISK_BUILD="7G"

IUSE="benchmark perfscripts test"
REQUIRED_USE="perfscripts? ( benchmark ) ${PYTHON_REQUIRED_USE} ${ROCM_REQUIRED_USE}"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-add-stdexcept-header.patch"
	"${FILESDIR}/${PN}-5.4.3-Add-missing-type-definitions.patch"
)

required_mem() {
	if use test; then
		echo "52G"
	else
		if [[ -n "${AMDGPU_TARGETS}" ]]; then
			local NARCH=$(($(awk -F";" '{print NF-1}' <<< "${AMDGPU_TARGETS}" || die)+1)) # count how many archs user specified in ${AMDGPU_TARGETS}
		else
			local NARCH=7 # The default number of AMDGPU_TARGETS for rocFFT-4.3.0. May change in the future.
		fi
		echo "$(($(makeopts_jobs)*${NARCH}*25+2200))M" # A linear function estimating how much memory required
	fi
}

pkg_pretend() {
	return # leave the disk space check to pkg_setup phase
}

pkg_setup() {
	export CHECKREQS_MEMORY=$(required_mem)
	check-reqs_pkg_setup
	python_setup
}

src_prepare() {
	pushd scripts/perf || die
	sed -e "/rocmversion/s,rocm_info.strip(),\"${PV}\"," -i perflib/specs.py || dir
	sed -e "/^top/,+1d" -i rocfft-perf suites.py || die
	sed -e "s,perflib,${PN}_perflib,g" -i rocfft-perf suites.py perflib/*.py || die
	sed -e "/^top = /s,__file__).*$,\"${EPREFIX}/usr/share/${PN}-perflib\")," -i perflib/pdf.py perflib/generators.py || die
	popd || die

	# https://github.com/RadeonOpenCompute/ROCm/issues/1905
	sed '/rocm_install(/ {:r;/)/!{N;br}; s,.*,,}' -i clients/tests/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-Wno-dev
		-DBUILD_CLIENTS_SELFTEST=$(usex test ON OFF)
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DPYTHON3_EXE=${EPYTHON}
		-DBUILD_CLIENTS_RIDER=$(usex benchmark ON OFF)
	)

	CXX=hipcc cmake_src_configure
}

src_compile() {
	# https://github.com/ROCmSoftwarePlatform/rocFFT/issues/389
	export ROCFFT_RTC_PROCESS=1
	cmake_src_compile
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export LD_LIBRARY_PATH=${BUILD_DIR}/library/src/:${BUILD_DIR}/library/src/device
	edob ./${PN,,}-test
}

src_install() {
	cmake_src_install

	if use perfscripts; then
		cd "${S}"/scripts/perf || die
		python_foreach_impl python_doexe rocfft-perf
		python_moduleinto ${PN}_perflib
		python_foreach_impl python_domodule perflib/*.py
		insinto /usr/share/${PN}-perflib
		doins *.asy suites.py
	fi
}
