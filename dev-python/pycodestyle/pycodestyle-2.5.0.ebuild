# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python2_7 python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Python style guide checker (fka pep8)"
HOMEPAGE="https://pypi.org/project/pycodestyle/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py -v --statistics pycodestyle.py || die
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py -v --max-doc-length=72 --testsuite=testsuite || die
	PYTHONPATH="${S}" "${PYTHON}" pycodestyle.py --doctest -v || die
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
