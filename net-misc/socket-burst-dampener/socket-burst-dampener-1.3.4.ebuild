# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..14} )
inherit distutils-r1 pypi

DESCRIPTION="A daemon that spawns one command per connection, and dampens connection bursts"
HOMEPAGE="https://github.com/zmedico/socket-burst-dampener"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -e "s/^__version__ =.*/__version__ = \"${PV}\"/" -i src/${PN//-/_}.py || die
	distutils-r1_src_prepare
}
