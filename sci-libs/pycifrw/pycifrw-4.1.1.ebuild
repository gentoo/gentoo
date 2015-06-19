# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/pycifrw/pycifrw-4.1.1.ebuild,v 1.1 2015/02/22 12:03:15 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="PyCifRW"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Reading and writing CIF (Crystallographic Information Format) files"
HOMEPAGE="https://pypi.python.org/pypi/PyCifRW/ https://bitbucket.org/jamesrhester/pycifrw/wiki/Home"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ASRP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
