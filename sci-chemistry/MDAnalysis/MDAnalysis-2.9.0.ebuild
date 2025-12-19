# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1

DESCRIPTION="A python library to analyze and manipulate molecular dynamics trajectories"
HOMEPAGE="https://www.mdanalysis.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/package-${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/mdanalysis-package-${PV}/package"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64"

# TODO: fix this
# ImportError: MDAnalysis not installed properly. This can happen if your C extensions have not been built.
RESTRICT="test"

RDEPEND="
	>=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0.0[${PYTHON_USEDEP}]
	>=sci-biology/biopython-1.71[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.0[${PYTHON_USEDEP}]
	>=dev-python/griddataformats-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.12[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/mmtf-python-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.43.0[${PYTHON_USEDEP}]
	>=dev-python/gsd-1.9.3[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_prepare() {
	# fix deprecated NPY API
	sed \
		-e "s:NPY_IN_ARRAY:NPY_ARRAY_IN_ARRAY:g" \
		-e "s:NPY_ALIGNED:NPY_ARRAY_ALIGNED:g" \
		-e "s:NPY_ENSURECOPY:NPY_ARRAY_ENSURECOPY:g" \
		-i MDAnalysis/lib/src/transformations/transformations.c || die
	distutils-r1_src_prepare
}
