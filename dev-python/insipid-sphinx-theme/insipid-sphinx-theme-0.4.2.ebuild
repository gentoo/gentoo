# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Insipid Sphinx theme"
HOMEPAGE="
	https://pypi.org/project/insipid-sphinx-theme/
	https://github.com/mgeier/insipid-sphinx-theme/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/sphinx-5[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.18[${PYTHON_USEDEP}]
"

DOCS=( {CONTRIBUTING,NEWS,README}.rst )

# needs sphinx_last_updated_by_git
#distutils_enable_sphinx "doc"
