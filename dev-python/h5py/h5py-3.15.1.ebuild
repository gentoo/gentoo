# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Simple Python interface to HDF5 files"
HOMEPAGE="
	https://www.h5py.org/
	https://github.com/h5py/h5py/
	https://pypi.org/project/h5py/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~arm64-macos ~x64-macos"
IUSE="examples"

DEPEND="
	>=dev-python/numpy-1.21.2:=[${PYTHON_USEDEP}]
	>=sci-libs/hdf5-1.10.4:=[hl(+)]
"
RDEPEND="
	${DEPEND}
"

BDEPEND="
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.14.5[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.5.5[${PYTHON_USEDEP}]
	>=dev-python/setuptools-77.0.1[${PYTHON_USEDEP}]
	test? (
		dev-python/qtpy[testlib,${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

python_prepare_all() {
	# avoid pytest-mpi dep, we do not use mpi anyway
	sed -i -e 's:pytest-mpi::' pytest.ini || die
	distutils-r1_python_prepare_all

	export H5PY_SETUP_REQUIRES=0
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest -m "not mpi"
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
