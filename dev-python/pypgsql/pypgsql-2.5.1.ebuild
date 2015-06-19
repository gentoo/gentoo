# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pypgsql/pypgsql-2.5.1.ebuild,v 1.10 2014/12/28 15:42:53 titanofold Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit distutils

MY_P="pyPgSQL-${PV}"

DESCRIPTION="Python Interface to PostgreSQL"
HOMEPAGE="http://pypgsql.sourceforge.net/ http://pypi.python.org/pypi/pyPgSQL"
SRC_URI="mirror://sourceforge/pypgsql/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="Announce"
PYTHON_MODNAME="pyPgSQL"

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins -r examples
}
