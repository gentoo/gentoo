# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnustep-2

MY_PN="GSPdf"
DESCRIPTION="Postscript and Pdf Viewer using GhostScript"
HOMEPAGE="http://gap.nongnu.org/gspdf/index.html"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="app-text/ghostscript-gpl"

S="${WORKDIR}/${MY_PN}-${PV}"
