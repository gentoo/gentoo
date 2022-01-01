# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Sphinx spelling extension"
HOMEPAGE="https://github.com/sphinx-contrib/spelling"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/importlib_metadata-1.7.0[${PYTHON_USEDEP}]
	' python3_{6,7})
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		app-dicts/myspell-en
	)
"

# The doc can only be built from a git repository
distutils_enable_tests pytest

# We don't want distutils_enable_tests to add the namespace
# package to BDEPEND under "test?". Therefore we add it to RDEPEND
# after running distutils_enable_tests.
RDEPEND+="
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# Needs to be run from a git repository
	sed -i 's/test_contributors/_&/' \
		tests/test_filter.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
