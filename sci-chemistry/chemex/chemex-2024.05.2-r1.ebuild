# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL="yes"
DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Program to fit chemical exchange induced shift and relaxation data"
HOMEPAGE="https://github.com/gbouvignies/chemex"
SRC_URI="https://github.com/gbouvignies/ChemEx/archive/refs/tags/v${PV/_p/-dev}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ChemEx-${PV/_p/-dev}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
# FIXME: Restrict until tests are readded https://github.com/gbouvignies/ChemEx/issues/51
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/annotated-types-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/cachetools-5.3.3[${PYTHON_USEDEP}]
		>=dev-python/emcee-3.1.4[${PYTHON_USEDEP}]
		>=dev-python/lmfit-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.8.4[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.6.4[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.13.0[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

export PDM_BUILD_SCM_VERSION=${PV}
