# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="PostgreSQL Extension Network Client"
HOMEPAGE="http://pgxnclient.projects.postgresql.org/ https://pypi.org/project/pgxnclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-db/postgresql-9.1[server]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	# suite written onlt for py2
	pushd ${PN} > /dev/null
	if ! python_is_python3; then
		PYTHONPATH=../ "${PYTHON}" -m unittest discover || die "tests failed"
	fi
	popd > dev/null
}
