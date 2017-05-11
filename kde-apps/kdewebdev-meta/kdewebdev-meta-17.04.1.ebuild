# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE WebDev - merge this to pull in all kdewebdev-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

# FIXME: Add back when ported
# $(add_kdeapps_dep klinkstatus)
RDEPEND="
	$(add_kdeapps_dep kfilereplace)
	$(add_kdeapps_dep kimagemapeditor)
	nls? ( $(add_kdeapps_dep kde4-l10n '' ${L10N_MINIMAL}) )
"
