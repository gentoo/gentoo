# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Pure-Python Implementation of the AES block-cipher and common modes of operation"
HOMEPAGE="https://pypi.python.org/pypi/pyaes"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPENDS="dev-python/setuptools"

#S=${WORKDIR}/${MY_P}
