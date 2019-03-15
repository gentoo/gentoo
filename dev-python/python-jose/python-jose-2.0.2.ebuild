# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
inherit distutils-r1

DESCRIPTION="A JOSE implementation in Python"
HOMEPAGE="https://pypi.org/project/python-jose/ http://github.com/mpdavis/python-jose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/setuptools-1.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-0.8[${PYTHON_USEDEP}]
	<dev-python/ecdsa-1.0.0[${PYTHON_USEDEP}]
	<dev-python/future-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.3.1[${PYTHON_USEDEP}]
	<dev-python/pycryptodome-4.0.0[${PYTHON_USEDEP}]
	<dev-python/six-2.0.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
