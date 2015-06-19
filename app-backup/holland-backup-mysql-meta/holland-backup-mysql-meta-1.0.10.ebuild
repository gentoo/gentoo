# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/holland-backup-mysql-meta/holland-backup-mysql-meta-1.0.10.ebuild,v 1.1 2014/09/21 23:41:32 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Holland MySQL"
HOMEPAGE="http://www.hollandbackup.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lvm +mysqldump mysqlhotcopy"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	lvm? ( ~app-backup/holland-backup-mysql-lvm-${PV}[${PYTHON_USEDEP}] )
	mysqldump? ( ~app-backup/holland-backup-mysqldump-${PV}[${PYTHON_USEDEP}] )
	mysqlhotcopy? ( ~app-backup/holland-backup-mysqlhotcopy-${PV}[${PYTHON_USEDEP}] )
"
PDEPEND="=app-backup/holland-${PV}[${PYTHON_USEDEP}]"
