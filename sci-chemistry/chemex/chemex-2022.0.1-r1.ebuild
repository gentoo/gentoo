# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL="yes"
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Program to fit chemical exchange induced shift and relaxation data"
HOMEPAGE="https://github.com/gbouvignies/chemex"
SRC_URI="https://github.com/gbouvignies/ChemEx/archive/refs/tags/v${PV/_p/-dev}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ChemEx-${PV/_p/-dev}"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="test"

#RESTRICT="!test? ( test )"
# FIXME: Restrict until tests are readded https://github.com/gbouvignies/ChemEx/issues/51
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/asteval-0.9.25[${PYTHON_USEDEP}]
		>=dev-python/cachetools-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/lmfit-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.5.3[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23.3[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.10.2[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/rich-12.5.1[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.9.1[${PYTHON_USEDEP}]
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
