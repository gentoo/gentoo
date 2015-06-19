# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gemas/gemas-0.3.ebuild,v 1.2 2012/06/07 20:12:03 xmw Exp $

EAPI=4
inherit gnustep-2

MY_P=${P/g/G}
DESCRIPTION="a simple code editor for GNUstep"
HOMEPAGE="http://wiki.gnustep.org/index.php/Gemas.app"
SRC_URI="http://download.gna.org/gnustep-nonfsf/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=gnustep-libs/highlighterkit-0.1.2
	>=virtual/gnustep-back-0.22.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
