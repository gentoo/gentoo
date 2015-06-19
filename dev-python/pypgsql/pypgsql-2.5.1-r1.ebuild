# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pypgsql/pypgsql-2.5.1-r1.ebuild,v 1.7 2015/01/04 22:27:12 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="pyPgSQL-${PV}"

DESCRIPTION="Python Interface to PostgreSQL"
HOMEPAGE="http://pypgsql.sourceforge.net/ http://pypi.python.org/pypi/pyPgSQL"
SRC_URI="mirror://sourceforge/pypgsql/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="examples"

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}
	dev-python/egenix-mx-base[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

CFLAGS="${CFLAGS} -fno-strict-aliasing"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
