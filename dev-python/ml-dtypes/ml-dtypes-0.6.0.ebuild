# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

MY_P=${PN/-/_}-${PV}
EIGEN_CommitId="bc3b39870ecb690a623a3f49149a358b95c5781d"

DESCRIPTION="A stand-alone implementation of several NumPy dtype extensions"
HOMEPAGE="
	https://github.com/jax-ml/ml_dtypes/
	https://pypi.org/project/ml-dtypes/
"
SRC_URI="
	https://github.com/jax-ml/ml_dtypes/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_CommitId}/eigen-${EIGEN_CommitId}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	>=dev-python/numpy-1.21:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
	test? (
		dev-python/absl-py[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	rmdir third_party/eigen || die
	mv "${WORKDIR}/eigen-${EIGEN_CommitId}" third_party/eigen || die
	distutils-r1_python_prepare_all
}

src_test() {
	mv ml_dtypes/tests . || die
	rm -r ml_dtypes || die

	distutils-r1_src_test
}
