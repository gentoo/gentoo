# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 eutils

MY_P=${P^}

DESCRIPTION="Define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
SRC_URI="mirror://pypi/${MY_P::1}/${MY_P%-*}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="test? ( dev-python/parameterized[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
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

pkg_postinst() {
	optfeature "Make picture of Theano computation graph" dev-python/pydot-ng
	optfeature "Required for GPU/CPU code generation" dev-python/pygpu
}
