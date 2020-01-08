# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.{4..6} 10 )
PYTHON_COMPAT=( python2_7 python3_{6..7} )

inherit distutils-r1 postgres

MY_P="PyGreSQL-${PV}"

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="http://www.pygresql.org/"
SRC_URI="mirror://pypi/P/PyGreSQL/${MY_P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~sparc x86"
IUSE=""

DEPEND="${POSTGRES_DEP}"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	local DOCS=( docs/*.rst docs/community/* docs/contents/tutorial.rst )

	distutils-r1_python_install_all
}
