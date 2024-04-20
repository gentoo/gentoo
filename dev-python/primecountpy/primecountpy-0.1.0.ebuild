# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="Cython interface to sci-mathematics/primecount"
HOMEPAGE="https://pypi.org/project/primecountpy/
	https://github.com/dimpase/primecountpy"

# LICENSE clarification in README.md
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="sci-mathematics/primecount
	dev-python/cysignals[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
