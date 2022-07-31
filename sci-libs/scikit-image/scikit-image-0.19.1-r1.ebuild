# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="https://scikit-image.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# It seems that scikit-image has not been built correctly.
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

distutils_enable_tests --install pytest
# TODO: package myst_parser
#distutils_enable_sphinx doc/source dev-python/numpydoc

pkg_postinst() {
	optfeature "FITS io capability" dev-python/astropy
	optfeature "GTK" dev-python/pygtk
	optfeature "Parallel computation" dev-python/dask
	optfeature "io plugin providing most standard formats" dev-python/imread
	# not in portage yet
	#optfeature "io plugin providing a wide variety of formats, including specialized formats using in medical imaging." dev-python/simpleitk
}
