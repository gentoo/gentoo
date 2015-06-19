# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wol/wol-0.7.1-r1.ebuild,v 1.5 2014/09/07 10:46:04 ago Exp $

EAPI=5

DESCRIPTION="Wake up hardware that is Magic Packet compliant"
HOMEPAGE="http://ahh.sourceforge.net/wol/"
SRC_URI="mirror://sourceforge/ahh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ~ppc64 x86 ~x86-fbsd"
IUSE="nls"

src_configure() {
	econf \
		$(use_enable nls)
}
