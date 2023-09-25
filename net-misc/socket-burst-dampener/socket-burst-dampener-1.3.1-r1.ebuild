# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="A daemon that spawns one command per connection, and dampens connection bursts"
HOMEPAGE="https://github.com/zmedico/socket-burst-dampener"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

src_prepare() {
	# remove "v" prefix from version
	sed -e '/__version__/s/"v/"/' -i src/${PN//-/_}.py || die
	distutils-r1_src_prepare
}
