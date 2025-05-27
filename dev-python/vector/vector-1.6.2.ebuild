# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi optfeature

DESCRIPTION="Vector classes and utilities"
HOMEPAGE="
	https://github.com/scikit-hep/vector
	https://pypi.org/project/vector/
	https://vector.readthedocs.io/
	https://doi.org/10.5281/zenodo.7054478
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-19[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

pkg_postinst() {
	optfeature "awkward array support" dev-python/awkward
	optfeature "sympy support" dev-python/sympy
}

EPYTEST_IGNORE=(
	# no module named papermill
	tests/test_notebooks.py
	# testing for exact (not mathematical) equality against sympy
	# which changes without being wrong...
	tests/compute/sympy/lorentz/
)

distutils_enable_tests pytest
