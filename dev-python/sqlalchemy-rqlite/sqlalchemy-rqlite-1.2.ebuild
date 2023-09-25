# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A SQLAlchemy dialect for rqlite"
HOMEPAGE="https://github.com/rqlite/sqlalchemy-rqlite"
SRC_URI="https://github.com/rqlite/sqlalchemy-rqlite/archive//v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyrqlite[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/sqlalchemy_rqlite/constants.py || die
	distutils-r1_src_prepare
}
