# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tipcutils/tipcutils-2.0.3.ebuild,v 1.1 2015/01/29 08:53:26 pinkbyte Exp $

EAPI=5

inherit eutils

DESCRIPTION="Utilities for TIPC (Transparent Inter-Process Communication)"
HOMEPAGE="http://tipc.sourceforge.net"
SRC_URI="mirror://sourceforge/tipc/${P}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sys-kernel/linux-headers-2.6.39"

DOCS=( README )

src_prepare() {
	epatch_user
}
