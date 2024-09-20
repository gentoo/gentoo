# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Python SNMP library"
HOMEPAGE="
	https://pypi.org/project/pysnmp/
	https://github.com/lextudio/pysnmp/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ~sparc x86"

PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
	>=dev-python/pysnmpcrypto-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/pysmi-1.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pysmi-1.3.0[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# TODO
# distutils_enable_sphinx docs/source dev-python/furo dev-python/sphinx-copybutton dev-python/sphinx-sitemap

python_test() {
	mibdump NET-SNMP-EXAMPLES-MIB || die
	epytest
}
