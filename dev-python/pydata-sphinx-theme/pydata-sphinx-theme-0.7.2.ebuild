# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Bootstrap-based Sphinx theme from the PyData community"
HOMEPAGE="https://github.com/pydata/pydata-sphinx-theme"
SRC_URI="https://github.com/pydata/pydata-sphinx-theme/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-with-disclosure"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
"

# TODO: fix this: Sandbox violation to /usr/local/share
#distutils_enable_sphinx docs dev-python/commonmark dev-python/recommonmark dev-python/numpydoc dev-python/jupyter-sphinx dev-python/plotly dev-python/xarray
distutils_enable_tests pytest
