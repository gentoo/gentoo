# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Python implementation of the JSON5 data format"
HOMEPAGE="
	https://github.com/dpranke/pyjson5/
	https://pypi.org/project/json5/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
