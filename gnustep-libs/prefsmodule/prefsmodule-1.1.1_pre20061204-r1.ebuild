# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnustep-2

S=${WORKDIR}/${PN/prefsm/PrefsM}

DESCRIPTION="Preferences is the GNUstep program with which you define your own personal user experience"
HOMEPAGE="http://www.nongnu.org/backbone/apps.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
