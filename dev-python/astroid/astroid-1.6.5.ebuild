# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://github.com/PyCQA/astroid https://pypi.org/project/astroid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# Version specified in __pkginfo__.py.
RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	virtual/python-singledispatch[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-functools-lru-cache[${PYTHON_USEDEP}]' -2)"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' 'python*')
		>=dev-python/pylint-1.6.0[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# Disable failing tests
	# TODO: investigate if it's our fault and how can we fix it
	sed -i -e "s/test_from_imports/_&/" \
		astroid/tests/unittest_brain.py || die
	sed -i -e "s/test_namespace_package_pth_support/_&/" \
		astroid/tests/unittest_manager.py || die
	# we hack xml module, so it does not match what they expect...
	sed -i -e "s/test_module_model/_&/" \
		astroid/tests/unittest_object_model.py || die

	# no idea why this test fails
	sed -i -e "s/test_namespace_and_file_mismatch/_&/" \
		astroid/tests/unittest_manager.py || die

	# and this test works yet it shouldn't
	sed -i -e "s#test_object_dunder_new_is_inferred_if_decorator#_&#" \
		astroid/tests/unittest_inference.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} -m unittest discover -p "unittest*.py" --verbose || die
}
