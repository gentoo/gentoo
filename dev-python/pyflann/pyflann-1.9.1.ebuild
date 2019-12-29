# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python bindings for FLANN artificial neural network library"
HOMEPAGE="http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN/"
SRC_URI="https://github.com/mariusmuja/flann/archive/${PV}.tar.gz -> flann-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~sci-libs/flann-${PV}"
DEPEND="${RDEPEND}"
# TODO:
# readd dependencies for test suite,
# requires repackaging auto-downloaded files

S="${WORKDIR}/flann-${PV}/src/python"

python_prepare_all() {
	sed -e "s/@FLANN_VERSION@/${PV}/" \
		-e '/package_d/d' \
		-e "s/,.*'pyflann.lib'//" \
		setup.py.tpl >> setup.py || die

	distutils-r1_python_prepare_all
}
