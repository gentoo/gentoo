# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1

DESCRIPTION="Administration tool for disaster recovery of PostgreSQL servers"

HOMEPAGE="https://www.pgbarman.org"
SRC_URI="https://downloads.sourceforge.net/project/pgbarman/${PV}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="dev-python/boto[${PYTHON_USEDEP}]
	dev-python/argh[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	net-misc/rsync
	dev-db/postgresql[server]"
DEPEND=""
