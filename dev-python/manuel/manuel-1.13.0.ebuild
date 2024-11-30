# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Lets you mix and match traditional doctests with custom test syntax"
HOMEPAGE="
	https://github.com/benji-york/manuel/
	https://pypi.org/project/manuel/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# unused rdep
	sed -e "/'setuptools'/d" -i setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	# tests are installed to site-packages but dependent data files
	# are not, so run them from src instead
	local -x PYTHONPATH=src
	"${EPYTHON}" -m unittest -vv manuel.tests.test_suite || die
}
