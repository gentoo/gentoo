# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 pypy3 )

inherit distutils-r1

DESCRIPTION="Enumerate IP addresses on the local network adapters"
HOMEPAGE="https://github.com/pydron/ifaddr"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""
