# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netprofiles-ims/netprofiles-ims-0.1.0134.ebuild,v 1.6 2014/08/10 20:45:26 slyfox Exp $

DESCRIPTION="The Netprofiles Interface Management System (IMS) is an easy way to manage multiple network configurations for your wired or wireless network cards"

HOMEPAGE="http://www.furuba.net/~buckminst/gentoo/"
SRC_URI="http://www.furuba.net/~buckminst/gentoo/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_install() {
	dosbin netprofiles
	doinitd netprofiles-ims
}
