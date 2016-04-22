# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="KDE SDK - merge this to pull in all kdesdk-derived packages"
HOMEPAGE="https://www.kde.org/applications/development"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cvs"

RDEPEND="
	cvs? ( $(add_kdeapps_dep cervisia) )
	$(add_kdeapps_dep dolphin-plugins)
	$(add_kdeapps_dep kapptemplate)
	$(add_kdeapps_dep kate)
	$(add_kdeapps_dep kcachegrind)
	$(add_kdeapps_dep kde-dev-scripts)
	$(add_kdeapps_dep kde-dev-utils)
	$(add_kdeapps_dep kdesdk-kioslaves)
	$(add_kdeapps_dep kompare)
	$(add_kdeapps_dep libkomparediff2)
	$(add_kdeapps_dep lokalize)
	$(add_kdeapps_dep okteta)
	$(add_kdeapps_dep poxml)
	$(add_kdeapps_dep umbrello)
"
