# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python style guide checker (fka pep8)"
HOMEPAGE="https://pypi.python.org/pypi/pycodestyle"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py -v --statistics pycodestyle.py || die
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py -v --testsuite=testsuite || die
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py --doctest -v || die
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
