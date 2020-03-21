# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python wrapper for OpenCL"
HOMEPAGE="https://mathema.tician.de/software/pyopencl
	https://pypi.org/project/pyopencl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples opengl"

RDEPEND="
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0:=[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.2.0[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pytools-2017.5[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=virtual/opencl-2"
DEPEND="${RDEPEND}"

src_configure() {
	local myconf=()
	if use opengl; then
		myconf+=(--cl-enable-gl)
	fi

	"${PYTHON}" configure.py \
		--boost-compiler=gcc \
		--boost-python-libname=boost_python-${PYTHON_ABI}-mt \
		--no-use-shipped-boost \
		--cl-pretend-version=1.2 \
		"${myconf[@]}"
}

python_install_all() {
	if use examples; then
		local EXAMPLES=( examples/. )
		einfo "Some of the examples provided by this package require dev-python/matplotlib."
	fi
	distutils-r1_python_install_all
}
