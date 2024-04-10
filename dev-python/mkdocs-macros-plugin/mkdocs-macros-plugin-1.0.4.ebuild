# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Mkdocs plug-in allowing the use of macros and variables in Markdown"
HOMEPAGE="
	https://mkdocs-macros-plugin.readthedocs.io/
	https://pypi.org/project/mkdocs-macros-plugin/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# TODO: enable these once the relevant deps have been packaged
RESTRICT="test"

RDEPEND="
	>=dev-python/mkdocs-0.17[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
