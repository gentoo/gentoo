# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 eutils

DESCRIPTION="Define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
SRC_URI="mirror://pypi/T/${PN^}/${PN^}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
	   dev-python/flake8[${PYTHON_USEDEP}]
	   dev-python/nose[${PYTHON_USEDEP}]
	   dev-python/parameterized[${PYTHON_USEDEP}]
	   dev-python/pyflakes[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${PN^}-${PV}"

python_prepare_all() {
	# remove bundled six
	find -type f -name "*.py" -exec \
		 sed -e 's:theano.compat.six:six:g' -i '{}' + || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	nosetests --verbosity=3 || die
}

pkg_postinst() {
	optfeature "Make picture of Theano computation graph" dev-python/pydot-ng
	optfeature "Required for GPU/CPU code generation" dev-python/pygpu
}
