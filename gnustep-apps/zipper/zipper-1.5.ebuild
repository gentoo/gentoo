# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/zipper/zipper-1.5.ebuild,v 1.4 2013/06/29 18:31:32 ago Exp $

EAPI=5

inherit gnustep-2

S=${WORKDIR}/${P/z/Z}

DESCRIPTION="Zipper is a tool for inspecting and extracting compressed archives"
HOMEPAGE="http://gap.nongnu.org/zipper"
SRC_URI="http://savannah.nongnu.org/download/gap/${P/z/Z}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
