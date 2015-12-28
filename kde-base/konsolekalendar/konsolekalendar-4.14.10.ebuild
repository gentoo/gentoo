# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="A command line interface to KDE calendars"
HOMEPAGE+=" https://userbase.kde.org/KonsoleKalendar"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs 'akonadi(+)')
	$(add_kdebase_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

KMCOMPILEONLY="
	calendarsupport/
	grantleetheme/
	incidenceeditor-ng/
	kaddressbookgrantlee/
	mailcommon/
	messagecore/
	messageviewer/
	pimcommon/
	templateparser/
"
KMEXTRACTONLY="
	akonadi_next/
	agents/mailfilteragent/org.freedesktop.Akonadi.MailFilterAgent.xml
	calendarviews/
	kdgantt2/
	korganizer/data/org.kde.Korganizer.Calendar.xml
	mailimporter/
	messagecomposer/
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
"

KMLOADLIBS="kdepim-common-libs"

PATCHES=( "${FILESDIR}/kdepim-4.14.10-fix-cmake-3.4.patch" )
