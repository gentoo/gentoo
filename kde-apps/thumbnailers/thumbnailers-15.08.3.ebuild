# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdegraphics-thumbnailers"
inherit kde4-base

DESCRIPTION="KDE 4 thumbnail generators for PDF/PS files"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkdcraw)
	$(add_kdeapps_dep libkexiv2)
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdebase-kioslaves)
"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	S="${WORKDIR}/${KMNAME}-${PV}"
fi
