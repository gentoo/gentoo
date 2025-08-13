# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Python SNMP library"
HOMEPAGE="
	https://pypi.org/project/pysnmp/
	https://github.com/lextudio/pysnmp/
"
SRC_URI="
	https://github.com/lextudio/pysnmp/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ~sparc x86"
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/cryptography-43.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
	>=dev-python/pysmi-1.5.7[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest
# TODO
# distutils_enable_sphinx docs/source dev-python/furo dev-python/sphinx-copybutton dev-python/sphinx-sitemap

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		tests/smi/manager/test_mib-tree-inspection.py::test_getNodeName_by_symbol_description_with_module_name_2
	)

	mibdump CISCO-ENHANCED-IPSEC-FLOW-MIB.py || die
	mibdump LEXTUDIO-TEST-MIB || die
	mibdump NET-SNMP-EXAMPLES-MIB || die
	mibdump IF-MIB || die
	epytest
}
