# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.12 blocked by mkdocs-material
DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Automatic documentation from sources, for MkDocs"
HOMEPAGE="
	https://mkdocstrings.github.io/
	https://github.com/mkdocstrings/mkdocstrings/
	https://pypi.org/project/mkdocstrings/
"
# Tests require files absent from PyPI tarballs
SRC_URI="
	https://github.com/mkdocstrings/mkdocstrings/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.3[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-1.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.5[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-autorefs-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-6.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/markdown-exec[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocstrings-python[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

# mkdocstrings documentation generation requires several currently
# unpackaged mkdocs extensions and plug-ins, and this test
# makes use of mkdocs configuration
EPYTEST_DESELECT=(
	tests/test_plugin.py::test_disabling_plugin
	# WTF, it tries to unlink installed files from installed package?!
	tests/test_handlers.py::test_extended_templates
	# Needs unpackaged mkdocs-callouts, mkdocs-literate-nav, and possibly more
	tests/test_inventory.py::test_sphinx_load_mkdocstrings_inventory_file
	# Internet
	tests/test_inventory.py::test_load_inventory
)

distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}
