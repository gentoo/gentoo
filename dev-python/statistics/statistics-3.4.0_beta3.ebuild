# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy pypy3 )

inherit distutils-r1

MY_P=${PN}-${PV/_beta/b}

DESCRIPTION="A Python 2.* port of 3.4 Statistics Module"
HOMEPAGE="https://github.com/digitalemagine/py-statistics
	https://pypi.org/project/statistics/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}
