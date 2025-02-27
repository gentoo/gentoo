# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Plugin for Mkdocs page redirects"
HOMEPAGE="
	https://github.com/mkdocs/mkdocs-redirects
	https://pypi.org/project/mkdocs-redirects/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-1.1.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
