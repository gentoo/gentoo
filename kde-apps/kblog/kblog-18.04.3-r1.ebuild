# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library providing client-side support for web application remote blogging APIs"
LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kxmlrpcclient)
	$(add_frameworks_dep syndication)
	$(add_kdeapps_dep kcalcore)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

PATCHES=( "${FILESDIR}/${P}-syndication.patch" )
