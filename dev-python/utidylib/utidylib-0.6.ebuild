# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

MY_P="uTidylib-${PV}"
inherit distutils-r1

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="https://cihar.com/software/utidylib/ https://pypi.org/project/uTidylib/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
IUSE="doc test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( || ( $(python_gen_useflags 'python2*' python3_6 python3_7) ) )
"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? ( $(python_gen_cond_dep '
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/pycodestyle[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		' 'python2*' python3_6 python3_7
	) )
"
DEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="
	app-text/tidy-html5
"

RESTRICT="test" # 1/11 tests fail

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
