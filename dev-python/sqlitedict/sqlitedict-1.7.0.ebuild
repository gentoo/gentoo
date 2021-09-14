# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Persistent dict in Python, backed by SQLite and pickle"
HOMEPAGE="https://github.com/piskvorky/sqlitedict"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

DOCS=(
	README.rst
)

python_test() {
	rm -f tests/db/* || die
	py.test -v || die
}
