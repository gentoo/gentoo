# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Strong cryptography support for PySNMP (SNMP library for Python)"
HOMEPAGE="
	https://pypi.org/project/pysnmpcrypto/
	https://github.com/lextudio/pysnmpcrypto
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ~sparc x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
