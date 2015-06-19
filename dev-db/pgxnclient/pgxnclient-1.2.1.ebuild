# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgxnclient/pgxnclient-1.2.1.ebuild,v 1.1 2015/06/14 15:30:05 patrick Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="PostgreSQL Extension Network Client"
HOMEPAGE="http://pgxnclient.projects.postgresql.org/ http://pypi.python.org/pypi/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="test"

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
