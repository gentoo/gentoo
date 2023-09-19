# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="MkDocs plugin to programmatically generate documentation pages during the build"
HOMEPAGE="
	https://oprypin.github.io/mkdocs-gen-files/
	https://pypi.org/project/mkdocs-gen-files/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND=">=dev-python/mkdocs-1.0.3[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/pytest-golden[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
