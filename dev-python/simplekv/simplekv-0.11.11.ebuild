# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit distutils-r1

DESCRIPTION="A key-value storage for binary data, support many backends."
HOMEPAGE="https://pypi.org/project/simplekv/ https://github.com/mbr/simplekv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
