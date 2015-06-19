# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/holland-backup-sqlite/holland-backup-sqlite-1.0.10.ebuild,v 1.1 2014/09/21 23:33:29 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Holland sqlite Plugin"
HOMEPAGE="http://www.hollandbackup.org/"

MY_P="${P%%-*}-${P##*-}"

SRC_URI="http://hollandbackup.org/releases/stable/${PV%.*}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="~app-backup/holland-lib-common-${PV}[${PYTHON_USEDEP}]"
PDEPEND="~app-backup/holland-${PV}[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}/plugins/${PN//-/.}"

python_install_all() {
	distutils-r1_python_install_all

	keepdir /etc/holland
	keepdir /etc/holland/backupsets
	keepdir /etc/holland/providers

	insinto /etc/holland/backupsets
	doins "${S}"/../../config/backupsets/examples/${PN##*-}.conf

	insinto /etc/holland/providers
	doins "${S}"/../../config/providers/${PN##*-}.conf
}
