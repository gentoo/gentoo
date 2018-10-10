# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A Python package for creating beautiful command line interfaces"
SRC_URI="https://github.com/pallets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://click.pocoo.org/ https://pypi.org/project/click/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/pallets-sphinx-themes[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	pytest -vv || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
