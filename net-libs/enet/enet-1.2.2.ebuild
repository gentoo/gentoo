# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/enet/enet-1.2.2.ebuild,v 1.2 2012/07/06 05:54:23 xmw Exp $

EAPI=3
inherit base

DESCRIPTION="relatively thin, simple and robust network communication layer on top of UDP"
HOMEPAGE="http://enet.bespin.org/"
SRC_URI="http://enet.bespin.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="static-libs"

DOCS=( "ChangeLog" "README" )

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}
