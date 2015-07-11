# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/calendarjanitor/calendarjanitor-4.14.10.ebuild,v 1.1 2015/07/11 11:49:27 johu Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="A tool to scan calendar data for buggy instances"
HOMEPAGE="http://www.kde.org/"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepim-common-libs)
	$(add_kdebase_dep kdepimlibs 'akonadi(+)')
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	calendarsupport/
"

KMLOADLIBS="kdepim-common-libs"
