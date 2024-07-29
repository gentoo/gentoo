# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension that automatically documents argparse commands and options"
HOMEPAGE="
	https://github.com/sphinx-doc/sphinx-argparse/
	https://pypi.org/project/sphinx-argparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
