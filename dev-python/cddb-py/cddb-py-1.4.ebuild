# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cddb-py/cddb-py-1.4.ebuild,v 1.14 2012/02/21 08:08:42 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit distutils

MY_PN="CDDB"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CDDB Module for Python"
HOMEPAGE="http://sourceforge.net/projects/cddb-py/"
SRC_URI="mirror://sourceforge/cddb-py/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="CDDB.py DiscID.py"
