# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=pdm

inherit distutils-r1

DESCRIPTION="Automatic documentation from sources, for MkDocs"
HOMEPAGE="https://mkdocstrings.github.io/ https://pypi.org/project/mkdocs-autorefs/"
# Tests require files absent from PyPI tarballs
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND=">=dev-python/jinja-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.3[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-1.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-autorefs-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-6.3[${PYTHON_USEDEP}]"
BDEPEND="test? (
	dev-python/mkdocs-material[${PYTHON_USEDEP}]
	dev-python/mkdocstrings-python[${PYTHON_USEDEP}]
)"

# mkdocstrings documentation generation requires several currently
# unpackaged mkdocs extensions and plug-ins, and this test
# makes use of mkdocs configuration
EPYTEST_DESELECT=(
	tests/test_plugin.py::test_disabling_plugin
)

distutils_enable_tests pytest
