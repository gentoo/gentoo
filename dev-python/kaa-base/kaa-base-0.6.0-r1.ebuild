# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite?,threads(+)"

inherit distutils-r1

DESCRIPTION="Basic Framework for all Kaa Python Modules"
HOMEPAGE="http://www.freevo.org/ http://api.freevo.org/kaa-base/"
SRC_URI="mirror://sourceforge/freevo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="lirc sqlite tls zeroconf"

DEPEND=">=dev-libs/glib-2.4.0:2
	sqlite? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	zeroconf? ( net-dns/avahi[python] )
"
RDEPEND="${DEPEND}
	dev-python/pynotifier[${PYTHON_USEDEP}]
	lirc? ( dev-python/pylirc[${PYTHON_USEDEP}] )
	tls? ( dev-python/tlslite[${PYTHON_USEDEP}] )"

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -i -e 's:from pysqlite2 import dbapi2:import sqlite3:' \
		src/db.py || die

	rm -fr src/pynotifier
	distutils-r1_python_prepare_all
}

python_compile() {
	local CFLAGS="${CFLAGS} -fno-strict-aliasing"
	export CFLAGS
	distutils-r1_python_compile
}
