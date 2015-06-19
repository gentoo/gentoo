# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/lapispuzzle/lapispuzzle-1.2.ebuild,v 1.1 2012/02/14 22:46:58 voyageur Exp $

EAPI=4
inherit gnustep-2

MY_P=LapisPuzzle-${PV}

DESCRIPTION="a Tetris-like game where each player is effected by the others game play"
HOMEPAGE="http://gap.nongnu.org/lapispuzzle/"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
