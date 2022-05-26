# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

MY_P="uTidylib-${PV}"
inherit distutils-r1

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="https://cihar.com/software/utidylib/ https://pypi.org/project/uTidylib/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ppc64 x86"
IUSE="doc test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
DEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="
	>=app-text/htmltidy-5.0.0
"

RESTRICT="!test? ( test )"

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
