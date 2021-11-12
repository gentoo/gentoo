# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_SINGLE_IMPL="yes"
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1

DESCRIPTION="Program to fit chemical exchange induced shift and relaxation data"
HOMEPAGE="https://github.com/gbouvignies/chemex"
SRC_URI="https://github.com/gbouvignies/chemex/archive/${PV/_p/-dev}.tar.gz -> ${P}.tar.gz"

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
		>=dev-python/jsonschema-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/lmfit-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.4.3[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.2[${PYTHON_USEDEP}]
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/tomlkit-0.7.2[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.61.1[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

S="${WORKDIR}/ChemEx-${PV/_p/-dev}"

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	distutils-r1_src_prepare
}
