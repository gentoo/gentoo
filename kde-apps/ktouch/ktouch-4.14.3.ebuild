# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/ktouch/ktouch-4.14.3.ebuild,v 1.1 2015/06/04 18:44:38 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: A program that helps you to learn and practice touch typing"
HOMEPAGE="http://edu.kde.org/applications/miscellaneous/ktouch"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep knotify)
	$(add_kdeapps_dep kqtquickcharts)
	$(add_kdeapps_dep plasma-runtime)
"
