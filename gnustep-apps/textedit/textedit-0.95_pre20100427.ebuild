# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/textedit/textedit-0.95_pre20100427.ebuild,v 1.4 2012/08/29 10:59:23 voyageur Exp $

EAPI=3
inherit eutils gnustep-2

S=${WORKDIR}/TextEdit

DESCRIPTION="A text editor with font, color, and style capabilities for GNUstep"
HOMEPAGE="http://www.nongnu.org/backbone/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

KEYWORDS="amd64 ~ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
}
