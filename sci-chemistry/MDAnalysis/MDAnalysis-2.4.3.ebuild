# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A python library to analyze and manipulate molecular dynamics trajectories"
HOMEPAGE="https://www.mdanalysis.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# TODO: fix this
# ImportError: MDAnalysis not installed properly. This can happen if your C extensions have not been built.
RESTRICT="test"

RDEPEND="
	>=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
	>=sci-biology/biopython-1.71[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.0[${PYTHON_USEDEP}]
	>=dev-python/GridDataFormats-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.12[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/mmtf-python-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.43.0[${PYTHON_USEDEP}]
	>=dev-python/gsd-1.9.3[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest
