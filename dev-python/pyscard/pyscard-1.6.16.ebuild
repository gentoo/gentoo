# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="pyscard is a python module adding smart cards support to python"
HOMEPAGE="http://pyscard.sourceforge.net/ http://pypi.python.org/pypi/pyscard"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	dev-lang/swig"

DOCS=( README smartcard/ACKS smartcard/ChangeLog smartcard/TODO )
