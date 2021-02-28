# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="A SQLAlchemy dialect for rqlite"
EGIT_REPO_URI="https://github.com/rqlite/sqlalchemy-rqlite.git"
HOMEPAGE="https://github.com/rqlite/sqlalchemy-rqlite"
SRC_URI="https://github.com/rqlite/sqlalchemy-rqlite/archive//v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyrqlite[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/sqlalchemy_rqlite/constants.py || die
	distutils-r1_src_prepare
}
