# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/thumbnailers/thumbnailers-4.14.3.ebuild,v 1.1 2015/06/04 18:44:42 kensington Exp $

EAPI=5

KMNAME="kdegraphics-thumbnailers"
inherit kde4-base

DESCRIPTION="KDE 4 thumbnail generators for PDF/PS files"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
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
