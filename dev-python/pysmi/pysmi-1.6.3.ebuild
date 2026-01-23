# Copyright 2017-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python implementation of SNMP/SMI MIB parsing and conversion library"
HOMEPAGE="
	https://github.com/lextudio/pysmi/
	https://pypi.org/project/pysmi/
"
# 1.6.1 removed tests
SRC_URI="
	https://github.com/lextudio/pysmi/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"

RDEPEND="
	>=dev-python/jinja2-3.1.3[${PYTHON_USEDEP}]
	>=dev-python/ply-3.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pysnmp-7.1.16[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# incompatibility with pysnmp >= 7
	tests/test_objecttype_smiv2_pysnmp.py::ObjectTypeBitsTestCase::testObjectTypeSyntax
)
