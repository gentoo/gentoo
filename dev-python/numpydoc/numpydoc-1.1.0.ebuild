# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to support docstrings in Numpy format"
HOMEPAGE="https://pypi.org/project/numpydoc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/matplotlib-3.2.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov-report= --cov=numpydoc::' setup.cfg || die

	# these require Internet (intersphinx)
	sed -e 's:test_MyClass:_&:' \
		-e 's:test_my_function:_&:' \
		-i numpydoc/tests/test_full.py || die

	distutils-r1_src_prepare
}

python_test() {
	pytest -vv --pyargs numpydoc || die "Tests failed with ${EPYTHON}"
}
