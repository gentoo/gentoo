# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/PyMca/PyMca-4.6.2-r1.ebuild,v 1.2 2015/04/08 18:22:13 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PV="${PV/_}"

DESCRIPTION="X-ray Fluorescence Toolkit"
HOMEPAGE="http://pymca.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/pymca/pymca/${PN}${PV/_p1}/pymca${MY_PV}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X hdf5 matplotlib"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	virtual/opengl
	X? (
	     dev-python/PyQt4[${PYTHON_USEDEP}]
	     dev-python/pyqwt[${PYTHON_USEDEP}]
	   )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${PN}${MY_PV}"

python_prepare_all() {
	local PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )
	export SPECFILE_USE_GNU_SOURCE=1
	distutils-r1_python_prepare_all
}
