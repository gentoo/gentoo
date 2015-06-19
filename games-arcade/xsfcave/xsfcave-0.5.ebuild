# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/xsfcave/xsfcave-0.5.ebuild,v 1.6 2015/01/06 09:46:55 tupone Exp $
EAPI=5
inherit games

DESCRIPTION="A X11 sfcave clone"
HOMEPAGE="http://xsfcave.idios.org"
SRC_URI="mirror://sourceforge/scrap/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-libs/libXext
	x11-libs/libSM"
RDEPEND="${DEPEND}"

src_install() {
	default
	prepgamesdirs
}
