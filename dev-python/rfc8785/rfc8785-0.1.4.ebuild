# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python impl. of RFC 8785 (JSON Canonicalization Scheme)"
HOMEPAGE="
	https://github.com/trailofbits/rfc8785.py/
	https://pypi.org/project/rfc8785/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
