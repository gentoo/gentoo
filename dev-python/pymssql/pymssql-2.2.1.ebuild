# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Simple MSSQL python extension module"
HOMEPAGE="https://www.pymssql.org/ https://pypi.org/project/pymssql/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"

# tests need a running instance of freetds
RESTRICT="test"

RDEPEND=">=dev-db/freetds-0.63[mssql]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${P}-clock_gettime.patch
)

distutils_enable_tests pytest

src_configure() {
	export LINK_FREETDS_STATICALLY=no
}
