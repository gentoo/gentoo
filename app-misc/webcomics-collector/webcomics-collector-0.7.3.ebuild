# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/webcomics-collector/webcomics-collector-0.7.3.ebuild,v 1.6 2011/01/12 14:35:31 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="gdbm"

inherit distutils

DESCRIPTION="python script for downloading webcomics"
HOMEPAGE="http://collector.skumleren.net/"
SRC_URI="http://collector.skumleren.net/releases/collector-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/collector-${PV}"

DOCS="UPGRADE"
PYTHON_MODNAME="Collector.py"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

pkg_postinst() {
	distutils_pkg_postinst

	ewarn "If you are upgrading from an earlier version of Collector, please"
	ewarn "read UPGRADE. This new version will not be able to use your old"
	ewarn "archives if you do not follow the upgrade instructions!"
}
