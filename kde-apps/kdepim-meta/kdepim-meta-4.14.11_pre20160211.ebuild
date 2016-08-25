# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5-meta-pkg

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE+=" https://community.kde.org/KDE_PIM"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="nls"
SLOT="4"

RDEPEND="
	kde-frameworks/oxygen-icons:5
	$(add_kdeapps_dep akonadiconsole '' 4.14.10)
	$(add_kdeapps_dep akregator '' 4.14.10)
	$(add_kdeapps_dep blogilo '' 4.14.10)
	$(add_kdeapps_dep calendarjanitor '' 4.14.10)
	$(add_kdeapps_dep kabcclient '' 4.14.10)
	$(add_kdeapps_dep kaddressbook '' 4.14.10)
	$(add_kdeapps_dep kalarm '' 4.14.10)
	$(add_kdeapps_dep kdepim-kresources '' 4.14.10)
	$(add_kdeapps_dep kdepim-runtime '' 4.14.10)
	$(add_kdeapps_dep kjots '' 4.14.10)
	$(add_kdeapps_dep kleopatra '' 4.14.10)
	$(add_kdeapps_dep kmail '' 4.14.10)
	$(add_kdeapps_dep knode '' 4.14.10)
	$(add_kdeapps_dep knotes '' 4.14.10)
	$(add_kdeapps_dep konsolekalendar '' 4.14.10)
	$(add_kdeapps_dep kontact '' 4.14.10)
	$(add_kdeapps_dep korganizer '' 4.14.10)
	$(add_kdeapps_dep ktimetracker '' 4.14.10)
	$(add_kdeapps_dep ktnef '' 4.14.10)
	nls? (
		$(add_kdeapps_dep kde4-l10n '' 4.14.3-r1)
		$(add_kdeapps_dep kdepim-l10n '' 4.14.3-r1)
	)
"
