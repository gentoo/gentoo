# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="
	https://scikit-image.org/
	https://github.com/scikit-image/scikit-image/
	https://pypi.org/project/scikit-image/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

RDEPEND="
	dev-python/imageio[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pywavelets[${PYTHON_USEDEP}]
	dev-python/scipy[sparse(+),${PYTHON_USEDEP}]
	dev-python/tifffile[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

DOCS=( CONTRIBUTORS.txt RELEASE.txt )

distutils_enable_tests pytest
# There is a programmable error in your configuration file:
#distutils_enable_sphinx doc/source dev-python/numpydoc dev-python/myst-parser

python_test() {
	# This needs to be run in the install dir
	cd "${WORKDIR}/${P}-${EPYTHON//./_}/install/usr/lib/${EPYTHON}/site-packages/skimage" || die
	distutils-r1_python_test
}

pkg_postinst() {
	optfeature "FITS io capability" dev-python/astropy
	optfeature "GTK" dev-python/pygtk
	optfeature "Parallel computation" dev-python/dask
	optfeature "io plugin providing most standard formats" dev-python/imread
	# not in portage yet
	#optfeature "io plugin providing a wide variety of formats, including specialized formats using in medical imaging." dev-python/simpleitk
}
