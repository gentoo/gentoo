# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python interface to the R language"
HOMEPAGE="
	https://rpy2.github.io/
	https://github.com/rpy2/rpy2/
	https://pypi.org/project/rpy/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-lang/R-4.0
	>=dev-python/rpy2-rinterface-3.6.3[${PYTHON_USEDEP}]
	>=dev-python/rpy2-robjects-3.6.3[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/cffi-1.15.0[${PYTHON_USEDEP}]
"
