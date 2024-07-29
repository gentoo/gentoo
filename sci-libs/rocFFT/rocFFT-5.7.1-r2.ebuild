# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
ROCM_VERSION=${PV}

inherit cmake check-reqs edo multiprocessing python-r1 rocm

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> rocFFT-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

# RDEPEND: perfscripts? dev-python/plotly[${PYTHON_USEDEP}] # currently masked by arch/amd64/x32/package.mask
RDEPEND="
perfscripts? (
	>=media-gfx/asymptote-2.61
	dev-texlive/texlive-latex
	dev-tex/latexmk
	sys-apps/texinfo
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}] )
${PYTHON_DEPS}"

DEPEND="=dev-util/hip-5*
	${PYTHON_DEPS}
	benchmark? (
		dev-libs/boost
		sci-libs/hipRAND:${SLOT}[${ROCM_USEDEP}]
	)
	test? (
		dev-cpp/gtest
		dev-libs/boost
		>=sci-libs/fftw-3
		sys-libs/libomp
		sci-libs/hipRAND:${SLOT}[${ROCM_USEDEP}]
	)
"

BDEPEND="
	>=dev-build/cmake-3.22
	dev-build/rocm-cmake
	dev-db/sqlite
"

CHECKREQS_DISK_BUILD="7G"

IUSE="benchmark perfscripts test"
REQUIRED_USE="perfscripts? ( benchmark ) ${PYTHON_REQUIRED_USE} ${ROCM_REQUIRED_USE}"

RESTRICT="!test? ( test )"

S="${WORKDIR}/rocFFT-rocm-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.7.1-fix-rocm-link-path.patch
)

required_mem() {
	if use test; then
		echo "52G"
	else
		if [[ -n "${AMDGPU_TARGETS}" ]]; then
			# count how many archs user specified in ${AMDGPU_TARGETS}
			local NARCH=$(($(awk -F";" '{print NF-1}' <<< "${AMDGPU_TARGETS}" || die)+1))
		else
			# The default number of AMDGPU_TARGETS for rocFFT-4.3.0. May change in the future.
			local NARCH=7
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
	sed -e "s/PREFIX rocfft//" \
		-e "/rocm_install_symlink_subdir/d" \
		-i library/src/CMakeLists.txt || die

	sed -e "/rocm_install_symlink_subdir/d" \
		-e "$!N;s:PREFIX\n[ ]*rocfft:# PREFIX rocfft\n:;P;D" \
		-i library/src/device/CMakeLists.txt || die

	if use perfscripts; then
		pushd scripts/perf || die
		sed -e "/\/opt\/rocm/d" -e "/rocmversion/s,rocm_info.strip(),\"${PV}\"," -i perflib/specs.py || dir
		sed -e "/^top/,+1d" -i rocfft-perf suites.py || die
		sed -e "s,perflib,${PN}_perflib,g" -i rocfft-perf suites.py perflib/*.py || die
		sed -e "/^top = /s,__file__).*$,\"${EPREFIX}/usr/share/${PN}-perflib\")," \
			-i perflib/pdf.py perflib/generators.py || die
		popd
	fi

	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-Wno-dev
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_RIDER=$(usex benchmark ON OFF)
		-DSQLITE_USE_SYSTEM_PACKAGE=ON
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	export LD_LIBRARY_PATH=${BUILD_DIR}/library/src/:${BUILD_DIR}/library/src/device
	edob ./${PN,,}-test
	edob ./${PN,,}-selftest
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}"/clients/staging || die
		dobin *rider

		if ! use perfscripts; then
			# prevent collision with dev-util/perf
			rm -rf "${ED}"/usr/bin/perf || die
		fi
	fi

	if use perfscripts; then
		cd "${S}"/scripts/perf || die
		python_foreach_impl python_doexe rocfft-perf
		python_moduleinto ${PN}_perflib
		python_foreach_impl python_domodule perflib/*.py
		insinto /usr/share/${PN}-perflib
		doins *.asy suites.py
	fi
}
