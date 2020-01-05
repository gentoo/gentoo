# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Simulating dynamics of open quantum systems in Python."
HOMEPAGE="http://qutip.org"
SRC_URI="https://github.com/qutip/qutip/archive/v$PV.tar.gz -> $P.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

python_prepare_all() {
	sed -i setup.py \
		-e 's/_compiler_flags = .*$/_compiler_flags = []/' || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	use openmp && mydistutilsargs=( --with-openmp )
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${EPYTHON} -c "import qutip.testing as qt ; qt.run()" || die
}
