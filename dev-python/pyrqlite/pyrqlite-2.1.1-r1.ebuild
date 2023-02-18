# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Python client for rqlite"
HOMEPAGE="https://github.com/rqlite/pyrqlite"
SRC_URI="https://github.com/rqlite/pyrqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rqlite/pyrqlite/pull/42.patch -> ${P}-test_cPragmaTableInfo.patch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( >=dev-db/rqlite-6.7.0 )"

PATCHES=( "${DISTDIR}/${P}-test_cPragmaTableInfo.patch" )

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/${PN}/constants.py || die
	distutils-r1_src_prepare
}
