# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-otr/pidgin-otr-3.2.1.ebuild,v 1.6 2013/06/20 14:25:13 polynomial-c Exp $

EAPI=5

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="http://www.cypherpunks.ca/otr/"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="<net-libs/libotr-4.0.0
	x11-libs/gtk+:2
	net-im/pidgin[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README )
