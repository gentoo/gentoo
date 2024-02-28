# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

PLOTLY_PV="5.13.0"

DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="https://plotly.com/python/"
SRC_URI="https://github.com/plotly/plotly.py/archive/refs/tags/v${PLOTLY_PV}.tar.gz -> plotly.py-${PLOTLY_PV}.gh.tar.gz"
S="${WORKDIR}/plotly.py-${PLOTLY_PV}/packages/python/${PN}"

# The warning about tests not being enabled is a false positive.
# Add distutils_enable_tests and restrict the tests to suppress the warning.
RESTRICT="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/plotly[${PYTHON_USEDEP}]
"

# There are sphinx docs but we are missing a bunch of dependencies.
# distutils_enable_sphinx ../../../doc/apidoc
distutils_enable_tests pytest
