# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_SINGLE_IMPL="yes"
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Program to fit chemical exchange induced shift and relaxation data"
HOMEPAGE="https://github.com/gbouvignies/chemex"
SRC_URI="https://github.com/gbouvignies/chemex/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/asteval-0.9.11[${PYTHON_MULTI_USEDEP}]
		>=dev-python/lmfit-0.9.11[${PYTHON_MULTI_USEDEP}]
		>=dev-python/matplotlib-1.1[${PYTHON_MULTI_USEDEP}]
		dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		dev-python/setuptools_scm[${PYTHON_MULTI_USEDEP}]
		>=dev-python/scipy-0.11[${PYTHON_MULTI_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

S="${WORKDIR}/ChemEx-${PV}"

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	distutils-r1_src_prepare
}
