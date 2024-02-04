# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PNGH="${PN/-/_}" # pypi is ml-dtypes, github is ml_dtypes
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

EIGEN_CommitId="7bf2968fed5f246c0589e1111004cb420fcd7c71"

DESCRIPTION="A stand-alone implementation of several NumPy dtype extensions"
HOMEPAGE="https://github.com/jax-ml/ml_dtypes"
SRC_URI="
	https://github.com/jax-ml/${PNGH}/archive/refs/tags/v${PV}.tar.gz -> ${PNGH}-${PV}.gh.tar.gz
	https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_CommitId}/eigen-${EIGEN_CommitId}.tar.bz2
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
"

python_prepare_all() {
	rmdir third_party/eigen || die
	cp -r "${WORKDIR}/eigen-${EIGEN_CommitId}" third_party/eigen || die
	distutils-r1_python_prepare_all
}
