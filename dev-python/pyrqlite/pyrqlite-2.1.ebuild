# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python client for rqlite"
HOMEPAGE="https://github.com/rqlite/pyrqlite"
SRC_URI="https://github.com/rqlite/pyrqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
BDEPEND="test? ( dev-db/rqlite )"

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/${PN}/constants.py || die
	distutils-r1_src_prepare
}
