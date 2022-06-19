# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Sphinx spelling extension"
HOMEPAGE="
	https://github.com/sphinx-contrib/spelling/
	https://pypi.org/project/sphinxcontrib-spelling/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		app-dicts/myspell-en
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires the git repo
	tests/test_filter.py::test_contributors
)

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	distutils_write_namespace sphinxcontrib
	rm -rf sphinxcontrib || die
	epytest tests
}
