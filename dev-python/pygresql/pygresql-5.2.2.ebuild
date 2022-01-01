# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.{5..6} {10..13} )
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 postgres

MY_P="PyGreSQL-${PV}"

DESCRIPTION="A Python interface for the PostgreSQL database"
HOMEPAGE="https://pygresql.org/"
SRC_URI="mirror://pypi/P/PyGreSQL/${MY_P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ~sparc ~x86"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}"/${PN}-5.2-CFLAGS.patch )

python_install_all() {
	local DOCS=( docs/*.rst docs/community/* docs/contents/tutorial.rst )

	distutils-r1_python_install_all
}
