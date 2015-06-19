# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gspdf/gspdf-0.4.ebuild,v 1.1 2010/11/22 14:42:56 voyageur Exp $

inherit eutils gnustep-2

MY_PN=GSPdf
DESCRIPTION="Postscript and Pdf Viewer using GhostScript"
HOMEPAGE="http://gap.nongnu.org/gspdf/index.html"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="app-text/ghostscript-gpl"

S=${WORKDIR}/${MY_PN}-${PV}
