# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE program that clicks the mouse for you"
HOMEPAGE="https://www.kde.org/applications/utilities/kmousetool/"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep knotify)
"
