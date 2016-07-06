# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE application that helps you manage system users"
HOMEPAGE="https://www.kde.org/applications/system/kuser/"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
"
# notify is needed for dialogs
RDEPEND="${DEPEND}
	$(add_kdeapps_dep knotify)
"
