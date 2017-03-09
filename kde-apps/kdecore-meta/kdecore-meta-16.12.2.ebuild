# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="kdecore - merge this to pull in the most basic applications"
KEYWORDS="~amd64 ~x86"
IUSE="+handbook nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

RDEPEND="
	$(add_kdeapps_dep dolphin)
	$(add_kdeapps_dep kdialog)
	$(add_kdeapps_dep keditbookmarks)
	$(add_kdeapps_dep kfind)
	$(add_kdeapps_dep konqueror)
	$(add_kdeapps_dep konsole)
	$(add_kdeapps_dep kwrite)
	handbook? ( $(add_kdeapps_dep khelpcenter) )
	nls? ( $(add_kdeapps_dep kde-l10n '' ${L10N_MINIMAL}) )
"
