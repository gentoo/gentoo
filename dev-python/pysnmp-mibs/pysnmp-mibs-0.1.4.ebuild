# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pysnmp-mibs/pysnmp-mibs-0.1.4.ebuild,v 1.1 2015/06/29 05:45:17 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="SNMP framework in Python - MIBs"
HOMEPAGE="http://pysnmp.sf.net/ http://pypi.python.org/pypi/pysnmp-mibs"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/pysnmp-4.2.2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
