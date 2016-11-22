# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5})

inherit distutils-r1

MY_PN="PyNaCl"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python binding to the Networking and Cryptography (NaCl) library"
HOMEPAGE="https://github.com/pyca/pynacl/ https://pypi.python.org/pypi/PyNaCl/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.1.0[${PYTHON_USEDEP}]
	dev-libs/libsodium:0/18
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}] )
"

S=${WORKDIR}/${MY_P}
