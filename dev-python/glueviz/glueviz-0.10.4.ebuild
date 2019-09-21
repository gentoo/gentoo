# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 eutils virtualx fdo-mime

DESCRIPTION="Python library to explore relationships within and among related datasets"
HOMEPAGE="http://www.glueviz.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD MIT"
SLOT="0"
IUSE="test"

# as of 0.10.0; broken
#RESTRICT="test"

DOCS=( README.rst )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP},designer,gui]
"

DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		  dev-python/glue-vispy-viewers[${PYTHON_USEDEP}]
		  dev-python/ipython[${PYTHON_USEDEP}]
		  dev-python/mock[${PYTHON_USEDEP}]
		  dev-python/pytest[${PYTHON_USEDEP}]
		  dev-python/qtconsole[${PYTHON_USEDEP}]
		  dev-python/QtPy[${PYTHON_USEDEP},designer,gui,testlib]
	)
"

python_test() {
	virtx esetup.py test
}

pkg_postinst() {
	optfeature "Interactive Ipython terminal" \
			   dev-python/ipython \
			   dev-python/ipykernel \
			   dev-python/qtconsole \
			   dev-python/traitlets \
			   dev-python/pygments \
			   dev-python/zmq
	optfeature "Parse AVM metadata" dev-python/pyavm
	optfeature "Save ${PN} sessions" dev-python/dill
	optfeature "Support HDF5 files" dev-python/h5py
	optfeature "Image processing calculations" sci-libs/scipy
	optfeature "Read popular image formats" sci-libs/scikits_image
	optfeature "Interact with Ginga viewer" dev-python/ginga
	optfeature "Export plots to plot.ly" dev-python/plotly
	optfeature "Support Excel reading" dev-python/xlrd
	optfeature "Used to read in spectral cubes" dev-python/spectral-cube
	optfeature "Support astronomy dendograms" dev-python/astrodendro

	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update
}
