# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/graphos/graphos-0.3.ebuild,v 1.1 2012/06/07 23:20:11 voyageur Exp $

EAPI=4
inherit eutils gnustep-2

MY_P=${PN/g/G}-${PV}
DESCRIPTION="vector drawing application centered around bezier paths"
HOMEPAGE="http://gap.nongnu.org/graphos/index.html"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}
