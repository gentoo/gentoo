# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/openggsn/openggsn-9999.ebuild,v 1.1 2014/05/01 16:58:36 zx2c4 Exp $

EAPI=5

inherit git-2 autotools

DESCRIPTION="Gateway GPRS Support Node"
HOMEPAGE="http://openbsc.osmocom.org/trac/wiki/OpenBSC_GPRS"
EGIT_REPO_URI="git://git.osmocom.org/openggsn"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
