# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

DESCRIPTION="Xdebug client for the Common Debugger Protocol (DBGP)"
HOMEPAGE="http://www.xdebug.org/"
SRC_URI="http://pecl.php.net/get/xdebug-${MY_PV}.tgz"
LICENSE="Xdebug"
SLOT="0"
IUSE="libedit"

S="${WORKDIR}/xdebug-${MY_PV}/debugclient"

DEPEND="libedit? ( dev-libs/libedit )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with libedit)
}

src_install() {
	newbin debugclient xdebug
}
