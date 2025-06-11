# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL="yes"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Program to fit chemical exchange induced shift and relaxation data"
HOMEPAGE="https://github.com/gbouvignies/chemex https://pypi.org/project/chemex/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
# FIXME: Restrict until tests are readded https://github.com/gbouvignies/ChemEx/issues/51
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/annotated-types-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/cachetools-5.5.1[${PYTHON_USEDEP}]
		>=dev-python/emcee-3.1.6[${PYTHON_USEDEP}]
		>=dev-python/lmfit-1.3.2[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-2.2.3[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.10.6[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-3.12.1[${PYTHON_USEDEP}]
		>=dev-python/rich-13.9.4[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.15.2[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
