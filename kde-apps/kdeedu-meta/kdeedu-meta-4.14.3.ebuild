# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kdeedu-meta/kdeedu-meta-4.14.3.ebuild,v 1.1 2015/06/04 18:44:50 kensington Exp $

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="http://edu.kde.org"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(add_kdeapps_dep analitza)
	$(add_kdeapps_dep artikulate)
	$(add_kdeapps_dep blinken)
	$(add_kdeapps_dep cantor)
	$(add_kdeapps_dep kalgebra)
	$(add_kdeapps_dep kalzium)
	$(add_kdeapps_dep kanagram)
	$(add_kdeapps_dep kbruch)
	$(add_kdeapps_dep kgeography)
	$(add_kdeapps_dep khangman)
	$(add_kdeapps_dep kig)
	$(add_kdeapps_dep kiten)
	$(add_kdeapps_dep klettres)
	$(add_kdeapps_dep kmplot)
	$(add_kdeapps_dep kqtquickcharts)
	$(add_kdeapps_dep kstars)
	$(add_kdeapps_dep ktouch)
	$(add_kdeapps_dep kturtle)
	$(add_kdeapps_dep kwordquiz)
	$(add_kdeapps_dep libkdeedu)
	$(add_kdeapps_dep marble)
	$(add_kdeapps_dep pairs)
	$(add_kdeapps_dep parley)
	$(add_kdeapps_dep rocs)
	$(add_kdeapps_dep step)
"
