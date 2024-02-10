# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Molecular Structures in Pandas DataFrames"
HOMEPAGE="
	https://rasbt.github.io/biopandas/
	https://github.com/BioPandas/biopandas
	https://pypi.org/project/biopandas/
"
SRC_URI="https://github.com/BioPandas/biopandas/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
