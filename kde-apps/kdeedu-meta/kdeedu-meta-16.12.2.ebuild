# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE educational apps - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="https://edu.kde.org"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep analitza)
	$(add_kdeapps_dep artikulate)
	$(add_kdeapps_dep blinken)
	$(add_kdeapps_dep cantor)
	$(add_kdeapps_dep kalgebra)
	$(add_kdeapps_dep kalzium)
	$(add_kdeapps_dep kanagram)
	$(add_kdeapps_dep kbruch)
	$(add_kdeapps_dep kdeedu-data)
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
	$(add_kdeapps_dep libkeduvocdocument)
	$(add_kdeapps_dep marble)
	$(add_kdeapps_dep minuet)
	$(add_kdeapps_dep parley)
	$(add_kdeapps_dep rocs)
	$(add_kdeapps_dep step)
	nls? ( $(add_kdeapps_dep kde-l10n '' ${L10N_MINIMAL}) )
"
