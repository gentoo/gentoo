# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517="poetry"

inherit distutils-r1 pypi

DESCRIPTION="Run tests in your markdown"
HOMEPAGE="
	https://github.com/Jc2k/pytest-markdown/
	https://pypi.org/project/pytest-markdown/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND=">=dev-python/commonmark-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]"
