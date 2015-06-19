# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/atpy/atpy-0.9.7.ebuild,v 1.5 2015/06/09 18:46:51 floppym Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

MYPN=ATpy
MYP="${MYPN}-${PV}"

DESCRIPTION="Astronomical tables support for Python"
HOMEPAGE="http://atpy.readthedocs.org/"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	postgres? ( dev-python/pygresql )"

IUSE="hdf5 mysql postgres sqlite"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

S="${WORKDIR}/${MYP}"

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" "${EPYTHON}" runtests.py || die
}
