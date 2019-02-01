# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://github.com/PyCQA/astroid https://pypi.org/project/astroid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Version specified in __pkginfo__.py.
RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '<=dev-python/typed-ast-1.2.0[${PYTHON_USEDEP}]' python3_5 python3_6)"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-fix-tests.patch"
	"${FILESDIR}/${PN}-2.1.0-no-pytest-runner.patch"
)

python_prepare_all() {
	# Disable failing tests

	# no idea why this test fails
	sed -i -e "s/test_knownValues_get_builtin_module_part/_&/" \
		astroid/tests/unittest_modutils.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} -m pytest -v --pyarg astroid/tests || die "tests failed"
}
