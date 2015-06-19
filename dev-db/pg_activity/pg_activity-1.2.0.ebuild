# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pg_activity/pg_activity-1.2.0.ebuild,v 1.1 2015/05/29 09:18:27 ago Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Realtime PostgreSQL database server monitoring tool"
HOMEPAGE="https://github.com/julmon/pg_activity/"
SRC_URI="https://github.com/julmon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="POSTGRESQL"

DEPEND=""
RDEPEND="dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	doman docs/man/${PN}.1
}
