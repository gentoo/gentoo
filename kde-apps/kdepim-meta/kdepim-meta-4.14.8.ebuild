# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE+=" https://community.kde.org/KDE_PIM"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="
	$(add_kdeapps_dep akonadiconsole)
	$(add_kdeapps_dep akregator)
	$(add_kdeapps_dep blogilo)
	$(add_kdeapps_dep calendarjanitor)
	$(add_kdeapps_dep kabcclient)
	$(add_kdeapps_dep kaddressbook)
	$(add_kdeapps_dep kalarm)
	|| (
		$(add_kdeapps_dep kdepim-icons)
		>=kde-frameworks/oxygen-icons-5.19.0:5
	)
	$(add_kdeapps_dep kdepim-kresources)
	$(add_kdeapps_dep kdepim-runtime)
	$(add_kdeapps_dep kjots)
	$(add_kdeapps_dep kleopatra)
	$(add_kdeapps_dep kmail)
	$(add_kdeapps_dep knode)
	$(add_kdeapps_dep knotes)
	$(add_kdeapps_dep konsolekalendar)
	$(add_kdeapps_dep kontact)
	$(add_kdeapps_dep korganizer)
	$(add_kdeapps_dep ktimetracker)
	$(add_kdeapps_dep ktnef)
	nls? (
		$(add_kdeapps_dep kde4-l10n '' 4.14.3)
		$(add_kdeapps_dep kdepim-l10n '' 4.14.3)
	)
"
