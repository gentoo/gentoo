# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="SNMP framework in Python - MIBs"
HOMEPAGE="http://pysnmp.sf.net/ https://pypi.python.org/pypi/pysnmp-mibs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-python/pysnmp-4.2.3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
