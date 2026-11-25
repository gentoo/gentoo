# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python impl. of RFC 8785 (JSON Canonicalization Scheme)"
HOMEPAGE="
	https://github.com/trailofbits/rfc8785.py/
	https://pypi.org/project/rfc8785/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
