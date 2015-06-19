# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/potr/potr-1.0.1.ebuild,v 1.2 2015/04/08 08:04:53 mgorny Exp $

EAPI=5

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Pure Python OTR implementation"
HOMEPAGE="https://github.com/python-otr/pure-python-otr"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND=">=dev-python/pycrypto-2.1[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"
