# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Bootstrap-based Sphinx theme from the PyData community"
HOMEPAGE="https://github.com/pydata/pydata-sphinx-theme"
SRC_URI="https://github.com/pydata/pydata-sphinx-theme/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-with-disclosure"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/beautifulsoup[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)"

# https://github.com/pydata/pydata-sphinx-theme/issues/367
RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	<dev-python/docutils-0.17[${PYTHON_USEDEP}]
"

# TODO: fix this: Sandbox violation to /usr/local/share
#distutils_enable_sphinx docs dev-python/commonmark dev-python/recommonmark dev-python/numpydoc dev-python/jupyter-sphinx dev-python/plotly dev-python/xarray
distutils_enable_tests pytest
