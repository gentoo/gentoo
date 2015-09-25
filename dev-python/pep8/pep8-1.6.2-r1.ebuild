# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python style guide checker"
HOMEPAGE="https://github.com/jcrocholl/pep8 https://pypi.python.org/pypi/pep8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-restore-flake8-compatibility.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="${S}" "${PYTHON}" pep8.py -v --testsuite=testsuite || die
	PYTHONPATH="${S}" "${PYTHON}" pep8.py --doctest -v || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
