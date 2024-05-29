# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python library and CLI tool for processing SBoM metadata"
HOMEPAGE="
	https://github.com/hughsie/python-uswid/
	https://pypi.org/project/uswid/
"

# Reminder: relicensed to BSD-2-with-patent between 0.4.7 and 0.5.0
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-python/cbor2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pefile[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
