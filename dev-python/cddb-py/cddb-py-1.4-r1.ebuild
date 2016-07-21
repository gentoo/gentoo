# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

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
