# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1
DESCRIPTION="A Python interface to libarchive"
HOMEPAGE="https://github.com/Changaco/python-libarchive-c/ https://pypi.python.org/pypi/libarchive-c/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
