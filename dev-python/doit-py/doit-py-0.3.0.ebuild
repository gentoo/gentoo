# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="doit tasks for python stuff"
HOMEPAGE="http://pythonhosted.org/doit-py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="
	virtual/python-pathlib[${PYTHON_USEDEP}]
	dev-python/doit[${PYTHON_USEDEP}]
	dev-python/configclass[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
