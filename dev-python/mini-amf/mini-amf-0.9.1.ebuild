# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..8} )
inherit distutils-r1

DESCRIPTION="Minimal AMF encoder and decoder for Python"
HOMEPAGE="https://pypi.python.org/pypi/Mini-AMF"
SRC_URI="https://github.com/zackw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)"
BDEPEND="doc? ( dev-python/sphinx )"

python_test() {
	coverage run --source=miniamf setup.py test || die
}

python_compile_all() {
	distutils-r1_python_compile

	if use doc ; then
		cd doc/ || die
		sphinx-build -b html . _build || die
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/. )
	einstalldocs

	distutils-r1_python_install_all
}
