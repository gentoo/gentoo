# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/adodb-py/adodb-py-2.20-r1.ebuild,v 1.9 2015/04/14 12:49:12 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite?'

inherit distutils-r1

MY_P=${PN/-py/}-${PV//./}

DESCRIPTION="Active Data Objects Data Base library for Python"
HOMEPAGE="http://adodb.sourceforge.net/"
SRC_URI="mirror://sourceforge/adodb/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE="mysql postgres sqlite"

RDEPEND="postgres? ( dev-python/psycopg:0[${PYTHON_USEDEP}] )
	mysql? ( >=dev-python/mysql-python-0.9.2[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}_sandbox_violation.patch"
)

python_install_all() {
	local HTML_DOCS=( adodb-py-docs.htm *.gif )
	distutils-r1_python_install_all
}
