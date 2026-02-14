# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/oprypin/mkdocs-gen-files
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="MkDocs plugin to programmatically generate documentation pages during the build"
HOMEPAGE="
	https://oprypin.github.io/mkdocs-gen-files/
	https://github.com/oprypin/mkdocs-gen-files/
	https://pypi.org/project/mkdocs-gen-files/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/mkdocs-1.4.1[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-golden )
distutils_enable_tests pytest
