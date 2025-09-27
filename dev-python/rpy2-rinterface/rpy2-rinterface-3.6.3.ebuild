# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Low-level interface from Python to the R"
HOMEPAGE="
	https://rpy2.github.io/
	https://github.com/rpy2/rpy2/
	https://pypi.org/project/rpy2-rinterface/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!<dev-python/rpy2-3.6.0
	>=dev-lang/R-4.0
	>=dev-python/cffi-1.15.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cffi-1.15.1[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
