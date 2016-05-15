# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1 eutils

DESCRIPTION="Python library to explore relationships within and among related datasets"
HOMEPAGE="http://www.glueviz.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD MIT"
SLOT="0"
IUSE="test"

# too much work to fix
RESTRICT="test"

DOCS=( README.md CHANGES.md )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	|| (
		  dev-python/PyQt4[${PYTHON_USEDEP}]
		  dev-python/pyside[${PYTHON_USEDEP}]
		  dev-python/PyQt5[${PYTHON_USEDEP}]
	   )"

DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		  dev-python/mock[${PYTHON_USEDEP}]
		  dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
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
	optfeature "Export plots to plot.ly" dev-python/plotly
}
