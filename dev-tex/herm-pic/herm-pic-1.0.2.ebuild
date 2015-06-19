# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/herm-pic/herm-pic-1.0.2.ebuild,v 1.3 2014/08/10 21:26:06 slyfox Exp $

inherit latex-package

DESCRIPTION="LaTeX class for creating ERM and HER diagramms"
HOMEPAGE="http://www.svenies-welt.de/?page_id=26"
SRC_URI="http://my.dex.de/~sven/downloads/${PN/-}_${PV}.tar.gz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN/-}"
TEXMF="/usr/share/texmf-site"
