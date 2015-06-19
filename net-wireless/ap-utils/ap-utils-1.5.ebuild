# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ap-utils/ap-utils-1.5.ebuild,v 1.2 2012/12/15 17:20:59 pacho Exp $

EAPI=5
inherit eutils

IUSE="nls"

DESCRIPTION="Wireless Access Point Utilities for Unix"
HOMEPAGE="http://ap-utils.polesye.net/"
SRC_URI="ftp://linux.zhitomir.net/ap-utils/ap-utils-1.5.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	>=sys-devel/bison-1.34"

src_configure() {
	econf $(use_enable nls)
}
