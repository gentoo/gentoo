# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

DESCRIPTION="Xdebug client for the Common Debugger Protocol (DBGP)"
HOMEPAGE="http://www.xdebug.org/"
SRC_URI="http://pecl.php.net/get/xdebug-${MY_PV}.tgz"

LICENSE="Xdebug"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="libedit"

DEPEND="libedit? ( dev-libs/libedit )
	net-libs/libnsl:0="
RDEPEND="${DEPEND}"
S="${WORKDIR}/xdebug-${MY_PV}/debugclient"

src_configure() {
	econf $(use_with libedit)
}

src_install() {
	newbin debugclient xdebug
}
