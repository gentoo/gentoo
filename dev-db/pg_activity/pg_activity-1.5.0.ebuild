# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Realtime PostgreSQL database server monitoring tool"
HOMEPAGE="https://github.com/julmon/pg_activity/"
SRC_URI="https://github.com/julmon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
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
