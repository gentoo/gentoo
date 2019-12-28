# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

MYPV=${PV/_/-}

DESCRIPTION="Python bindings to libgpuarray"
HOMEPAGE="http://deeplearning.net/software/libgpuarray/"
SRC_URI="https://github.com/Theano/libgpuarray/archive/v${MYPV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda opencl test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-libs/libgpuarray:=[cuda?,opencl?]
"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/libgpuarray-${MYPV}"

python_test() {
	local DEVICE=cuda
	use opencl && DEVICE=opencl
	nosetests -svw "${BUILD_DIR}/lib/" || die
}
