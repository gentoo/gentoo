# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: A program that helps you to learn and practice touch typing"
HOMEPAGE="https://edu.kde.org/applications/miscellaneous/ktouch"
KEYWORDS=" amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep knotify)
	$(add_kdeapps_dep kqtquickcharts)
	$(add_kdeapps_dep plasma-runtime)
"
