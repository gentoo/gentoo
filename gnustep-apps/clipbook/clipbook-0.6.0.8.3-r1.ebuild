# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/clipbook/clipbook-0.6.0.8.3-r1.ebuild,v 1.5 2014/08/10 21:19:32 slyfox Exp $

inherit gnustep-2

S=${WORKDIR}/GWorkspace-${PV/0.6.}/${PN/clipb/ClipB}

DESCRIPTION="A clipboard for GNUstep that can hold things for later copy and paste"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/gworkspace-${PV/0.6.}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"
