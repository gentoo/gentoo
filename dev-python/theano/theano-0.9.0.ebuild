# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1 versionator

MYPN=Theano
MYP=${MYPN}-$(replace_version_separator 3 '')

DESCRIPTION="Define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

SLOT="0"
LICENSE="BSD"
IUSE="doc test"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

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
	   dev-python/nose-parameterized[${PYTHON_USEDEP}]
	   dev-python/pyflakes[${PYTHON_USEDEP}]
	)"
S="${WORKDIR}/${MYP}"

python_prepare_all() {
	# remove bundled six
	find -type f -name "*.py" -exec \
		 sed -e 's:theano.compat.six:six:g' -i '{}' + || die
	rm ${PN}/compat/six.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbosity=3 || die
}

pkg_postinst() {
	optfeature "Make picture of Theano computation graph" dev-python/pydot-ng
	optfeature "Required for GPU/CPU code generation" dev-python/pygpu
}
