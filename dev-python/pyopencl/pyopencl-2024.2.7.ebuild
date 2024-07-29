# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="
	https://mathema.tician.de/software/pyopencl/
	https://pypi.org/project/pyopencl/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples opengl"

# Running tests on GPUs requires both appropriate hardware and additional permissions
# having been granted to the user running them. Testing on CPUs with dev-libs/pocl
# is in theory possible but has been found to be very fragile, see e.g. Bug #872308.
RESTRICT="test"

COMMON=">=virtual/opencl-2"
# libglvnd is only needed for the headers
DEPEND="
	${COMMON}
	opengl? ( media-libs/libglvnd )
"
RDEPEND="
	${COMMON}
	>=dev-python/mako-0.3.6[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytools-2024.1.5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/nanobind[${PYTHON_USEDEP}]
	test? ( dev-libs/pocl )
"

PATCHES=(
	"${FILESDIR}"/pyopencl-2024.2.7-nanobind-flags.patch
)

distutils_enable_tests pytest

python_configure_all() {
	DISTUTILS_ARGS=(
		-DPYOPENCL_ENABLE_GL=$(usex opengl)
	)
}

python_test() {
	# Use dev-libs/pocl for testing; ignore any other OpenCL devices that might be present
	local -x PYOPENCL_TEST="portable:pthread"
	# Set the number of threads to match MAKEOPTS
	local -x POCL_MAX_PTHREAD_COUNT=$(makeopts_jobs)
	# Change to the 'test' directory so that python does not try to import pyopencl from the source directory
	# (Importing from the source directory fails, because the compiled '_cl' module is only in the build directory)
	pushd test >/dev/null || die
	epytest
	popd >/dev/null || die
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
