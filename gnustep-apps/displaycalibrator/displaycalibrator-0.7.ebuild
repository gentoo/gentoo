# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/displaycalibrator/displaycalibrator-0.7.ebuild,v 1.4 2008/03/08 13:25:59 coldwind Exp $

inherit gnustep-2

DESCRIPTION="Frontend to xgamma"
HOMEPAGE="http://www.linuks.mine.nu/displaycalibrator/"
SRC_URI="http://www.linuks.mine.nu/displaycalibrator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="x11-apps/xgamma"
