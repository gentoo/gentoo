# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="python ODBC module to connect to almost any database"
HOMEPAGE="https://github.com/mkleehammer/pyodbc"
SRC_URI="https://pyodbc.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mssql"

RDEPEND=">=dev-db/unixODBC-2.3.0
	mssql? ( >=dev-db/freetds-0.64[odbc] )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_configure_all() {
	append-cxxflags -fno-strict-aliasing
}
