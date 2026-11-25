# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Fast Base64 encoding and decoding for Python, built on simdutf"
HOMEPAGE="
	https://pypi.org/project/fastpybase64/
	https://github.com/simdutf/fastpybase64
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-cpp/simdutf:=
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
