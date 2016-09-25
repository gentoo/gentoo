# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="XMDS - The eXtensible Multi-Dimensional Simulator"
HOMEPAGE="http://www.xmds.org"
SRC_URI="mirror://sourceforge/xmds/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples mpi"

DEPEND="dev-python/cheetah[${PYTHON_USEDEP}]"
RDEPEND=">=sci-libs/fftw-3.3.1:3.0=[mpi?]
		mpi? ( virtual/mpi )
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyparsing[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mpmath[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		sci-libs/atlas
		sci-libs/hdf5
		sci-libs/gsl"
#virtual/cblas

python_install_all() {
	use doc && HTML_DOCS+=( documentation/. )
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "Configure XMDS2 by typing"
	elog "xmds2 --reconfigure"
	elog "See http://www.xmds.org/installation.html for further informations"
}
