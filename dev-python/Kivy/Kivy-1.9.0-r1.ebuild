# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="A software library for rapid development of hardware-accelerated multitouch applications"
HOMEPAGE="http://kivy.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cairo camera doc examples garden gstreamer spell"

RDEPEND="
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	cairo? ( dev-python/pycairo[${PYTHON_USEDEP}] )
	camera? ( media-libs/opencv )
	garden? ( dev-python/kivy-garden[${PYTHON_USEDEP}] )
	gstreamer? ( dev-python/gst-python:1.0[${PYTHON_USEDEP}] )
	spell? ( dev-python/pyenchant[${PYTHON_USEDEP}] )
	"
DEPEND="${RDEPEND}
	<=dev-python/cython-0.22[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/mesa
"

PATCHES=( "${FILESDIR}"/${P}-cython-0.22-backport.patch )

python_prepare_all() {
	sed -e '/data_files=/d' -i "${S}/setup.py" || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && DOCS=( doc/sources/. )
	use examples && EXAMPLES=( examples )
	distutils-r1_python_install_all
}
