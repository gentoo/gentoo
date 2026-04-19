# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/authlib/joserfc
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for JOSE RFCs: JWS, JWE, JWK, JWA, JWT"
HOMEPAGE="
	https://github.com/authlib/joserfc/
	https://pypi.org/project/joserfc/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/cryptography-45.0.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
