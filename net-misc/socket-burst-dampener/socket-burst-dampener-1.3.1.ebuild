# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A daemon that spawns one command per connection, and dampens connection bursts"
HOMEPAGE="https://github.com/zmedico/socket-burst-dampener"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

distutils_enable_tests pytest

src_prepare() {
	# remove "v" prefix from version
	sed -e '/__version__/s/"v/"/' -i src/${PN//-/_}.py || die
	distutils-r1_src_prepare
}
