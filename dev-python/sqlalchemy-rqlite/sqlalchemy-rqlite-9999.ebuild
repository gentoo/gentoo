# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

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
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pyrqlite[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
	)"

src_prepare() {
	sed -e "s:^__version__ = .*:__version__ = '${PV}':" -i src/sqlalchemy_rqlite/constants.py || die
	distutils-r1_src_prepare
}

python_test() {
	esetup.py test || die "tests failed"
	esetup.py lint -f text -E || die "pylint failed"
}
