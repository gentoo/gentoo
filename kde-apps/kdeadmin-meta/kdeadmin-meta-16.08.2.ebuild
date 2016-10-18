# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
KEYWORDS="~amd64 ~x86"
IUSE="+cron nls"

[[ ${KDE_BUILD_TYPE} = live ]] && L10N_MINIMAL=${KDE_APPS_MINIMAL}

# FIXME: Add back when ported
# $(add_kdeapps_dep kuser)
RDEPEND="
	$(add_kdeapps_dep ksystemlog)
	cron? ( $(add_kdeapps_dep kcron) )
	nls? ( $(add_kdeapps_dep kde-l10n '' ${L10N_MINIMAL}) )
"
