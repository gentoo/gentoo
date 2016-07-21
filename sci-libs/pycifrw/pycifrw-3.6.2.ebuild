# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="PyCifRW"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides support for reading and writing of CIF using python"
HOMEPAGE="https://pypi.python.org/pypi/PyCifRW/ https://bitbucket.org/jamesrhester/pycifrw/wiki/Home"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ASRP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
