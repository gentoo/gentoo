# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdegraphics-thumbnailers"
inherit kde5

DESCRIPTION="Thumbnail generators for PDF/PS and RAW files"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_kdeapps_dep libkdcraw)
	$(add_kdeapps_dep libkexiv2)
	$(add_frameworks_dep kio)
	dev-qt/qtgui:5
"
RDEPEND="${DEPEND}"
