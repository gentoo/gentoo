# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/calendarjanitor/calendarjanitor-4.14.8.ebuild,v 1.3 2015/06/13 08:34:13 zlogene Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="A tool to scan calendar data for buggy instances"
HOMEPAGE="http://www.kde.org/"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepim-common-libs)
	$(add_kdebase_dep kdepimlibs)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	calendarsupport/
"

KMLOADLIBS="kdepim-common-libs"
