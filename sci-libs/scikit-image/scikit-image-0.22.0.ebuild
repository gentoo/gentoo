# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=meson-python
DISTUTILS_EXT=1
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

PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	>=dev-python/imageio-2.27[${PYTHON_USEDEP}]
	>=dev-python/lazy_loader-0.3[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.0.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.8[sparse(+),${PYTHON_USEDEP}]
	>=dev-python/tifffile-2022.8.12[${PYTHON_USEDEP}]
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
	cd "${WORKDIR}/${PN//-/_}-${PV}-${EPYTHON//./_}/install/usr/lib/${EPYTHON}/site-packages/skimage" || die
	distutils-r1_python_test
}

pkg_postinst() {
	optfeature "FITS io capability" dev-python/astropy
	optfeature "GTK" dev-python/pygtk
	optfeature "Parallel computation" dev-python/dask
	optfeature "io plugin providing most standard formats" dev-python/imread
	optfeature "plotting" dev-python/matplotlib
	optfeature "wavelet transformations" dev-python/pywavelets
	optfeature "io plugin providing a wide variety of formats, including specialized formats using in medical imaging." dev-python/simpleitk
}
