# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-meta-pkg

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE+=" https://community.kde.org/KDE_PIM"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="
	$(add_kdeapps_dep akonadiconsole '' ${PV})
	$(add_kdeapps_dep akregator '' ${PV})
	$(add_kdeapps_dep blogilo '' ${PV})
	$(add_kdeapps_dep calendarjanitor '' ${PV})
	$(add_kdeapps_dep kabcclient '' ${PV})
	$(add_kdeapps_dep kaddressbook '' ${PV})
	$(add_kdeapps_dep kalarm '' ${PV})
	|| (
		$(add_kdeapps_dep kdepim-icons)
		>=kde-frameworks/oxygen-icons-5.19.0:5
	)
	$(add_kdeapps_dep kdepim-kresources '' ${PV})
	$(add_kdeapps_dep kdepim-runtime '' ${PV})
	$(add_kdeapps_dep kjots '' ${PV})
	$(add_kdeapps_dep kleopatra '' ${PV})
	$(add_kdeapps_dep kmail '' ${PV})
	$(add_kdeapps_dep knode '' ${PV})
	$(add_kdeapps_dep knotes '' ${PV})
	$(add_kdeapps_dep konsolekalendar '' ${PV})
	$(add_kdeapps_dep kontact '' ${PV})
	$(add_kdeapps_dep korganizer '' ${PV})
	$(add_kdeapps_dep ktimetracker '' ${PV})
	$(add_kdeapps_dep ktnef '' ${PV})
	nls? (
		$(add_kdeapps_dep kde4-l10n '' 4.14.3-r1)
		$(add_kdeapps_dep kdepim-l10n '' 4.14.3-r1)
	)
"
