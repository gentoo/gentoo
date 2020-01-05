# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python{2_7,3_6} )

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
