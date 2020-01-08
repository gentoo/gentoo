# Copyright 2016-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="scp module for paramiko"
HOMEPAGE="https://github.com/jbardin/scp.py"
LICENSE="LGPL-2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

RDEPEND="
	dev-python/paramiko[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
