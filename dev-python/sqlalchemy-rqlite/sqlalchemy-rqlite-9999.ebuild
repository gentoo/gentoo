# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
fi

DESCRIPTION="A SQLAlchemy dialect for rqlite"
EGIT_REPO_URI="https://github.com/rqlite/sqlalchemy-rqlite.git"
HOMEPAGE="https://github.com/rqlite/sqlalchemy-rqlite"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-python/pyrqlite[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/sqlalchemy_rqlite/constants.py || die
	distutils-r1_src_prepare
}
