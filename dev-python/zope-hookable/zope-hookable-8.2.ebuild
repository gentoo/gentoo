# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Efficient creation of 'hookable' objects"
HOMEPAGE="
	https://pypi.org/project/zope.hookable/
	https://github.com/zopefoundation/zope.hookable/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)/zope"
}
