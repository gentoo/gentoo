# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="An event driven meteor client"
HOMEPAGE="https://pypi.org/project/python-meteor/ https://github.com/hharnisc/python-meteor"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/python-ddp[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
