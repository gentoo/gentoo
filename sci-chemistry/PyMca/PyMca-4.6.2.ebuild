# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-pypy-*"

inherit distutils eutils

MY_PV="${PV/_}"

DESCRIPTION="X-ray Fluorescence Toolkit"
HOMEPAGE="http://pymca.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/pymca/pymca/${PN}${PV/_p1}/pymca${MY_PV}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X hdf5 matplotlib"

DEPEND="
	dev-python/numpy
	dev-python/sip
	virtual/opengl
	dev-python/pyopengl
	X? (
	     dev-python/PyQt4
	     dev-python/pyqwt
	   )
	hdf5? ( dev-python/h5py )
	matplotlib? ( dev-python/matplotlib )"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${PN}${MY_PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	export SPECFILE_USE_GNU_SOURCE=1
	distutils_src_prepare
}
