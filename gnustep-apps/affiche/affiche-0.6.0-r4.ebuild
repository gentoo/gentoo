# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-2

DESCRIPTION="Affiche allows people to 'stick' notes"
HOMEPAGE="http://www.collaboration-world.com/affiche"
SRC_URI="http://www.collaboration-world.com/affiche.data/releases/Stable/${P/a/A}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

S=${WORKDIR}/${PN/a/A}
