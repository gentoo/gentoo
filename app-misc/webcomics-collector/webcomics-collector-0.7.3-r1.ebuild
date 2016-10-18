# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="gdbm"

inherit distutils-r1

DESCRIPTION="python script for downloading webcomics"
HOMEPAGE="http://collector.skumleren.net/"
SRC_URI="http://collector.skumleren.net/releases/collector-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/collector-${PV}"

DOCS=( Changelog README UPGRADE )

python_install() {
	distutils-r1_python_install
	python_fix_shebang "${ED}"usr/share/collector
}

pkg_postinst() {
	ewarn "If you are upgrading from an earlier version of Collector, please"
	ewarn "read UPGRADE. This new version will not be able to use your old"
	ewarn "archives if you do not follow the upgrade instructions!"
}
