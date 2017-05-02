# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://bitbucket.org/logilab/astroid https://pypi.python.org/pypi/astroid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86 ~x64-macos ~x86-macos"
IUSE="test"

# Version specified in __pkginfo__.py.
RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.6.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		virtual/python-singledispatch[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]' python2_7 )
		$(python_gen_cond_dep 'dev-python/functools32[${PYTHON_USEDEP}]' python2_7 )
		$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7 )
	)"
# Required for tests
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare() {
	# Disable failing test
	sed -i -e "/test_namespace_package_pth_support/a\\        return" astroid/tests/unittest_manager.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} -m unittest discover -p "unittest*.py" --verbose || die
}
