# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Jupyter Notebook Tools for Sphinx"
HOMEPAGE="
	https://github.com/spatialaudio/nbsphinx/
	https://pypi.org/project/nbsphinx/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.8[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5[${PYTHON_USEDEP}]
"
