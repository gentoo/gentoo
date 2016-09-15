# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="An event driven meteor client"
HOMEPAGE="https://pypi.python.org/pypi/python-meteor https://github.com/hharnisc/python-meteor"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/python-ddp[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
