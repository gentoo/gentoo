# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 multiprocessing

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="https://mathema.tician.de/software/pyopencl/
	https://pypi.org/project/pyopencl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="examples opengl"

COMMON=">=virtual/opencl-2"
# libglvnd is only needed for the headers
DEPEND="${COMMON}
	opengl? ( media-libs/libglvnd )"
RDEPEND="${COMMON}
	>=dev-python/mako-0.3.6[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytools-2021.2.7[${PYTHON_USEDEP}]"
BDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.5.0[${PYTHON_USEDEP}]
	test? ( dev-libs/pocl )"

distutils_enable_tests pytest

python_configure_all() {
	local myconf=()
	if use opengl; then
		myconf+=(--cl-enable-gl)
	fi

	"${EPYTHON}" configure.py \
		"${myconf[@]}"
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
