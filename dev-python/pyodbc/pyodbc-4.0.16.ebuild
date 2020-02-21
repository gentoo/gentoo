# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="python ODBC module to connect to almost any database"
HOMEPAGE="https://github.com/mkleehammer/pyodbc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mssql"

RDEPEND=">=dev-db/unixODBC-2.3.0
	mssql? ( >=dev-db/freetds-0.64[odbc] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_configure_all() {
	append-cxxflags -fno-strict-aliasing
}
