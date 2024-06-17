# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python-Markdown extension providing LaTeX-style 'include' function"
HOMEPAGE="
	https://github.com/cmacmackin/markdown-include
	https://pypi.org/project/markdown-include/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/markdown-3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.1-setup.patch
)

distutils_enable_tests pytest
