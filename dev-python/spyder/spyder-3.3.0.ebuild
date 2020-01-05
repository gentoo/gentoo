# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit eutils distutils-r1 xdg-utils

DESCRIPTION="The Scientific PYthon Development EnviRonment"
HOMEPAGE="
	https://www.spyder-ide.org/
	https://github.com/spyder-ide/spyder/
	https://pypi.org/project/spyder/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hdf5 +webengine webkit"
REQUIRED_USE="webengine? ( !webkit )"

RDEPEND="
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/pycodestyle[${PYTHON_USEDEP}]
	dev-python/pickleshare[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyflakes[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	>=dev-python/qtawesome-0.4.1[${PYTHON_USEDEP}]
	dev-python/qtconsole[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP},svg,webengine?,webkit?]
	>=dev-python/rope-0.10.7[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/numpydoc[${PYTHON_USEDEP}]
	<dev-python/spyder-kernels-1.0"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# Based on the courtesy of Arfrever
PATCHES=( "${FILESDIR}"/${P}-build.patch )

python_install() {
	distutils-r1_python_install
	python_newscript scripts/${PN} ${PN}${EPYTHON:6:1}
}

python_install_all() {
	distutils-r1_python_install_all
	doicon spyder/images/spyder.svg
	make_desktop_entry spyder Spyder spyder "Development;IDE"
}

pkg_postinst() {
	xdg_desktop_database_update

	elog "To get additional features, optional runtime dependencies may be installed:"
		optfeature "2D/3D plotting in the Python and IPython consoles" dev-python/matplotlib
		optfeature "View and edit DataFrames and Series in the Variable Explorer" dev-python/pandas
		optfeature "View and edit two or three dimensional arrays in the Variable Explorer" dev-python/numpy
		optfeature "Symbolic mathematics in the IPython console" dev-python/sympy
		optfeature "Import Matlab workspace files in the Variable Explorer" sci-libs/scipy
		optfeature "Run Cython files in the IPython console" dev-python/cython
}

pkg_postrm() {
	xdg_desktop_database_update
}
