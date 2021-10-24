# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python client for rqlite"
HOMEPAGE="https://github.com/rqlite/pyrqlite"
SRC_URI="https://github.com/rqlite/pyrqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rqlite/pyrqlite/pull/36.patch -> ${P}-python3.10-test_support.patch
	https://github.com/rqlite/pyrqlite/raw/17a22221e4e796a04c28aa578a93821cc3349b41/src/pyrqlite/_ephemeral.py -> ${P}-rqlite-6.7.0-ephemeral.py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( >=dev-db/rqlite-6.7.0 )"
RESTRICT+=" !test? ( test )"

PATCHES=("${DISTDIR}/${P}-python3.10-test_support.patch")

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/${PN}/constants.py || die
	cp "${DISTDIR}/${P}-rqlite-6.7.0-ephemeral.py" src/pyrqlite/_ephemeral.py || die
	distutils-r1_src_prepare
}
