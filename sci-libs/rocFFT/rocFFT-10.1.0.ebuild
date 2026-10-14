# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
ROCM_VERSION=${PV}

inherit cmake check-reqs edob flag-o-matic multiprocessing python-r1 rocm toolchain-funcs

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocfft"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rocfft.tar.gz
		-> rocfft-${PV}.tar.gz
"
S="${WORKDIR}/rocfft"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

# RDEPEND: perfscripts? dev-python/plotly[${PYTHON_USEDEP}] # currently masked by arch/amd64/x32/package.mask
RDEPEND="
	>=dev-db/sqlite-3.51.3:3
	dev-util/hip:=
	perfscripts? (
		media-gfx/asymptote
		dev-texlive/texlive-latex
		dev-tex/latexmk
		sys-apps/texinfo
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
"

DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	dev-util/hip:${SLOT}
	benchmark? (
		dev-db/sqlite:3
		dev-util/hip:=
		sci-libs/hipRAND:${SLOT}
	)
	test? (
		dev-cpp/gtest
		sci-libs/fftw
		llvm-runtimes/openmp
		sci-libs/hipRAND:${SLOT}
	)
"

BDEPEND="
	dev-build/rocm-cmake
	dev-db/sqlite
"

CHECKREQS_DISK_BUILD="7G"

IUSE="benchmark perfscripts test"
REQUIRED_USE="perfscripts? ( benchmark ) ${PYTHON_REQUIRED_USE} ${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-accountant-teardown.patch
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
	if use perfscripts; then
		pushd scripts/perf || die
		sed -e "s,rocmversion = rocm_info.strip(),rocmversion = \"${PV}\"," -i perflib/specs.py || die
		sed -e "/^top/,+1d" -i rocfft-perf suites.py || die
		sed -e "s,perflib,${PN}_perflib,g" -i rocfft-perf suites.py perflib/*.py || die
		sed -e "/^top = /s,__file__).*$,\"${EPREFIX}/usr/share/${PN}-perflib\")," \
			-i perflib/pdf.py perflib/generators.py || die
		popd || die
	fi

	# SPIR-V fallback for unselected GPUs needs dev-libs/rocm-comgr with SPIR-V support,
	# and clang rejects some CFLAGS (-frecord-gcc-switches) for spirv64
	sed -e "/offload-arch=amdgcnspirv/d" \
		-i clients/tests/CMakeLists.txt clients/bench/CMakeLists.txt || die

	# libc++ does not include <iterator> transitively
	sed -e "/#include <optional>/i #include <iterator>" \
		-i library/src/include/load_store_ops.h || die

	# length[1] is read for 1D transforms too (out of bounds)
	sed -e "s/const auto y_total = length\[1\] - 1;/const auto y_total = length.size() > 1 ? length[1] - 1 : 0;/" \
		-i shared/data_gen_device.cpp || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	# #977921: LTO is not compatible with -fgpu-rtc
	# See also: https://github.com/ROCm/hip/issues/3879
	filter-lto

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-Wno-dev
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCH=$(usex benchmark ON OFF)
		-DSQLITE_USE_SYSTEM_PACKAGE=ON
	)

	cmake_src_configure
}

src_compile() {
	# rocfft_aot_helper (kernel cache) queries visible GPUs, but doesn't use them
	rocm_add_sandbox
	cmake_src_compile
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}/clients/staging" || die
	# JIT callbacks link SPIR-V, which needs dev-libs/rocm-comgr with SPIR-V support
	local -x GTEST_FILTER="-*JITCB*:*multi_gpu*"
	# libc++ std::hash<double> is the identity, and the test "corrupts" the buffer by doubling
	# every value: the sum of the hashes then changes by N * 2^52, which is 0 mod 2^64
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		GTEST_FILTER+=":rocfft_UnitTest.buffer_hashing_double"
	fi
	# upstream "standard" tier; default memory limits are total VRAM (whole GTT on APUs) and RAM
	# use_fork: the clone()d "threadsafe" death test child segfaults in libsandbox
	LD_LIBRARY_PATH="${BUILD_DIR}/library/src" HIP_VISIBLE_DEVICES=0 \
		edob ./rocfft-test --test_prob 0.02 --R 16 --V 2 --gtest_death_test_use_fork
}

src_install() {
	cmake_src_install
	rm -rf "${ED}"/usr/.info || die

	if use benchmark; then
		cd "${BUILD_DIR}"/clients/staging || die
		dobin dyna-rocfft-bench rocfft-bench
		dosym dyna-rocfft-bench /usr/bin/dyna-rocfft-rider
		dosym rocfft-bench /usr/bin/rocfft-rider

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
