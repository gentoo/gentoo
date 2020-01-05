# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A daemon that spawns one command per connection, and dampens connection bursts"
HOMEPAGE="https://github.com/zmedico/socket-burst-damener"
SRC_URI="https://github.com/zmedico/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i "s:^\(__version__ =\).*:\\1 \"${PV}\":" src/${PN//-/_}.py || die
	distutils-r1_src_prepare
}
