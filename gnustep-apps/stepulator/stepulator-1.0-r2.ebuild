# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/stepulator/stepulator-1.0-r2.ebuild,v 1.4 2008/03/08 13:47:46 coldwind Exp $

inherit gnustep-2

S=${WORKDIR}/${PN/s/S}-gs

DESCRIPTION="A Reverse Polish Notation calculator"
HOMEPAGE="http://www.linuks.mine.nu/stepulator/index.html"
SRC_URI="http://www.linuks.mine.nu/stepulator/${PN}-gs-${PV}.tar.Z"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
