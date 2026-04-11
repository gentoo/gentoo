# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python library and CLI tool for processing SBoM metadata"
HOMEPAGE="
	https://github.com/hughsie/python-uswid/
	https://pypi.org/project/uswid/
"

LICENSE="BSD-2-with-patent"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	dev-python/cbor2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pefile[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
