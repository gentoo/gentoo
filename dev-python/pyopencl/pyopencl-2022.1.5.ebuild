# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="https://mathema.tician.de/software/pyopencl/
	https://pypi.org/project/pyopencl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples opengl"

DEPEND=">=virtual/opencl-2"
RDEPEND="${DEPEND}
	>=dev-python/mako-0.3.6[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytools-2021.2.7[${PYTHON_USEDEP}]"
# libglvnd is only needed for the headers
BDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.5.0[${PYTHON_USEDEP}]
	<dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
	opengl? ( media-libs/libglvnd )"

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
