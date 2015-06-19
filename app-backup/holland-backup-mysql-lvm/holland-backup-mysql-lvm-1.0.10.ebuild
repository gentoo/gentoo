# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/holland-backup-mysql-lvm/holland-backup-mysql-lvm-1.0.10.ebuild,v 1.1 2014/09/21 23:40:54 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Holland MySQL with LVM Plugin"
HOMEPAGE="http://www.hollandbackup.org/"

MY_P="${P%%-*}-${P##*-}"

SRC_URI="http://hollandbackup.org/releases/stable/${PV%.*}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	~app-backup/holland-backup-mysqldump-${PV}[${PYTHON_USEDEP}]
	~app-backup/holland-lib-common-${PV}[${PYTHON_USEDEP}]
	~app-backup/holland-lib-lvm-${PV}[${PYTHON_USEDEP}]
	~app-backup/holland-lib-mysql-${PV}[${PYTHON_USEDEP}]
"
PDEPEND="
	~app-backup/holland-${PV}[${PYTHON_USEDEP}]
	~app-backup/holland-backup-mysql-meta-${PV}[${PYTHON_USEDEP}]
	~app-backup/holland-backup-mysql-meta-${PV}[mysqldump]
"

S="${WORKDIR}/${MY_P}/plugins/${PN//-/.}"
S="${S/.lvm/_lvm}"

python_install_all() {
	distutils-r1_python_install_all

	keepdir /etc/holland
	keepdir /etc/holland/backupsets
	keepdir /etc/holland/providers

	insinto /etc/holland/backupsets
	doins "${S}"/../../config/backupsets/examples/mysql-lvm.conf
	doins "${S}"/../../config/backupsets/examples/mysqldump-lvm.conf

	insinto /etc/holland/providers
	doins "${S}"/../../config/providers/mysql-lvm.conf
	doins "${S}"/../../config/providers/mysqldump-lvm.conf
}
