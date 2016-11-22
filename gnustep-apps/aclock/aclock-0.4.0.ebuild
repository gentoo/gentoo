# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnustep-2

MY_P=${P/ac/AC}
DESCRIPTION="Analog dockapp clock for GNUstep"
HOMEPAGE="http://gap.nongnu.org/aclock/"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

gnustep_config_script() {
	echo "echo ' * using smooth seconds'"
	echo "defaults write AClock SmoothSeconds YES"
	echo "echo ' * setting refresh rate to 0.1 seconds'"
	echo "defaults write AClock RefreshRate 0.1"
}
