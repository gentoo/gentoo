# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

MY_P=${P^}

DESCRIPTION="Define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
SRC_URI="mirror://pypi/${MY_P::1}/${MY_P%-*}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
# Tests sometimes hang. dev-python/theano-pymc is better. #738416
# This package is on the way out anyway for that fork.
RESTRICT="test"

BDEPEND="test? ( dev-python/parameterized[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

src_prepare() {
	sed -i -e "s/, 'flake8'//" setup.py || die

	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	nosetests --verbosity=3 -e test_format_flake8 || die
}

# https://dev.gentoo.org/~mgorny/python-guide/concept.html#packaging-pkgutil-style-namespaces-in-gentoo
python_install() {
	rm "${BUILD_DIR}"/lib/bin/__init__.py || die
	distutils-r1_python_install
}

pkg_postinst() {
	optfeature "Make picture of Theano computation graph" dev-python/pydot-ng
	optfeature "Required for GPU/CPU code generation" dev-python/pygpu
}
