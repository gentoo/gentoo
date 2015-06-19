# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/barman/barman-1.4.1.ebuild,v 1.1 2015/05/11 04:06:22 patrick Exp $
EAPI=5

PYTHON_COMPAT=( python2_7)

inherit distutils-r1

DESCRIPTION="Administration tool for disaster recovery of PostgreSQL servers"

HOMEPAGE="http://www.pgbarman.org"
SRC_URI="http://downloads.sourceforge.net/project/pgbarman/${PV}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="dev-python/argh[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	net-misc/rsync
	dev-db/postgresql[server]"
DEPEND=""
