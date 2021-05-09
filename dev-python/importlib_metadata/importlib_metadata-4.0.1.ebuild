# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# NB: this package extends beyond built-in importlib stuff in py3.8+
# new entry_point API not yet included in cpython release
PYTHON_COMPAT=( pypy3 python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Read metadata from Python packages"
HOMEPAGE="https://github.com/python/importlib_metadata"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

RDEPEND="
	$(python_gen_cond_dep 'dev-python/typing-extensions[${PYTHON_USEDEP}]' python3_{6,7})
	dev-python/zipp[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/importlib_resources[${PYTHON_USEDEP}]
		' pypy3 python3_{7,8})
	)
"

distutils_enable_sphinx docs dev-python/jaraco-packaging dev-python/rst-linker
distutils_enable_tests unittest

python_prepare_all() {
	# Skip a test that requires pep517 which is not in the tree
	sed -e 's:test_find_local:_&:' -i tests/test_integration.py || die

	distutils-r1_python_prepare_all
}
