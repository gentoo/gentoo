# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="LibMTP bindings for Python"
HOMEPAGE="http://packages.debian.org/libmtp http://libmtp.sourceforge.net/ https://pypi.python.org/pypi/PyMTP"
DEB_URI="mirror://debian/pool/main/${PN:0:1}/${PN}"
SRC_URI="${DEB_URI}/${PN}_${PV}.orig.tar.gz"

LICENSE=GPL-3
SLOT=0
KEYWORDS="amd64 ppc x86"
IUSE="examples"

RDEPEND="media-libs/libmtp"
DEPEND=${RDEPEND}

S="${WORKDIR}"/PyMTP-${PV}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
