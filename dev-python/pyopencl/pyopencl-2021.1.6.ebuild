# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="https://mathema.tician.de/software/pyopencl/
	https://pypi.org/project/pyopencl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples opengl"

COMMON="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${COMMON}
	>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.2.0[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/pytools-2017.6[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=virtual/opencl-2"
DEPEND="${COMMON}
	dev-python/pybind11[${PYTHON_USEDEP}]"

# The test suite fails if there are no OpenCL platforms available, and
# even if there is one (which requires the presence of both an OpenCL
# runtime *and* hardware supported by it - simply emerging any runtime
# is not enough) the vast majority of tests end up skipped because by
# default the portage user hasn't got sufficient privileges to talk
# to the GPU.
RESTRICT="test"

python_configure_all() {
	local myconf=()
	if use opengl; then
		myconf+=(--cl-enable-gl)
	fi

	"${EPYTHON}" configure.py \
		"${myconf[@]}"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
