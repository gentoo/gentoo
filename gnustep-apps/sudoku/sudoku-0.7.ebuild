# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnustep-2

MY_PN=${PN/s/S}
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="Sudoku generator for GNUstep"
HOMEPAGE="http://gap.nongnu.org/sudoku/"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE=""
