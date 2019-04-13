# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

MY_PN="xdebug"
MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

inherit autotools

DESCRIPTION="Xdebug client for the Common Debugger Protocol (DBGP)"
HOMEPAGE="https://xdebug.org/"
# Using tarball from GitHub for tests
#SRC_URI="http://pecl.php.net/get/xdebug-${MY_PV}.tgz"
SRC_URI="https://github.com/xdebug/xdebug/archive/${MY_PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
LICENSE="Xdebug"
SLOT="0"
IUSE="libedit"

S="${WORKDIR}/${MY_PN}-${MY_PV}/debugclient"

DEPEND="libedit? ( dev-libs/libedit ) net-libs/libnsl:0="
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_with libedit)
}

src_install() {
	newbin debugclient xdebug
}
