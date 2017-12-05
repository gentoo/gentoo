# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-meta-pkg

DESCRIPTION="KDE administration tools - merge this to pull in all kdeadmin-derived packages"
KEYWORDS="amd64 x86"
IUSE="+cron"

RDEPEND="
	$(add_kdeapps_dep ksystemlog)
	cron? ( $(add_kdeapps_dep kcron) )
"
