# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/osmocom-bb/osmocom-bb-9999.ebuild,v 1.1 2014/04/29 01:21:55 zx2c4 Exp $

EAPI=5

inherit git-2 autotools flag-o-matic

DESCRIPTION="OsmocomBB MS-side GSM Protocol stack (L1, L2, L3) excluding firmware"
HOMEPAGE="http://bb.osmocom.org"
EGIT_REPO_URI="git://git.osmocom.org/osmocom-bb.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+transmit"

DEPEND="net-libs/libosmocore"
RDEPEND="${DEPEND}"

src_prepare() {
	use transmit && append-cflags "-DCONFIG_TX_ENABLE"

	cd src/host/osmocon && eautoreconf && cd ../../.. || die
	cd src/host/gsmmap && eautoreconf && cd ../../.. || die
	cd src/host/layer23 && eautoreconf && cd ../../.. || die
}

src_configure() {
	cd src/host/osmocon && econf && cd ../../.. || die
	cd src/host/gsmmap && econf && cd ../../.. || die
	cd src/host/layer23 && econf && cd ../../.. || die
}

src_compile() {
	cd src/host/osmocon && emake && cd ../../.. || die
	cd src/host/gsmmap && emake && cd ../../.. || die
	cd src/host/layer23 && emake && cd ../../.. || die

}

src_install() {
	cd src/host/osmocon && emake install DESTDIR="${D}" && cd ../../.. || die
	cd src/host/gsmmap && emake install DESTDIR="${D}" && cd ../../.. || die
	cd src/host/layer23 && emake install DESTDIR="${D}" && cd ../../.. || die
}
