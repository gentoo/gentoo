# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/adodb-py/adodb-py-2.20.ebuild,v 1.8 2013/01/17 16:11:04 mgorny Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_USE_WITH=sqlite?

inherit distutils eutils

MY_PV=${PV//./}
MY_P=${PN/-py/}-${MY_PV}

DESCRIPTION="Active Data Objects Data Base library for Python"
HOMEPAGE="http://adodb.sourceforge.net/"
SRC_URI="mirror://sourceforge/adodb/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ia64 ppc ~ppc64 x86"
IUSE="mysql postgres sqlite"

RDEPEND="postgres? ( dev-python/psycopg:0 )
	mysql? ( >=dev-python/mysql-python-0.9.2 )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="adodb"

src_prepare(){
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}_sandbox_violation.patch"
}

src_install() {
	distutils_src_install
	dohtml adodb-py-docs.htm *.gif || die "dohtml failed"
}
