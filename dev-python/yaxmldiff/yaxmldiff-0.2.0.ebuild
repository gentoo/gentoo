# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Yet Another XML Differ"
HOMEPAGE="
	https://pypi.org/project/yaxmldiff/
	https://github.com/latk/yaxmldiff.py
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~loong ~x86"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-fancy-pypi-readme-24.1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
