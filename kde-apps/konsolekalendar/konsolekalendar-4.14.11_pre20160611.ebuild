# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="Command line interface to KDE calendars"
HOMEPAGE+=" https://userbase.kde.org/KonsoleKalendar"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepim-common-libs '' 4.14.11_pre20160611)
	$(add_kdeapps_dep kdepimlibs '' 4.14.11_pre20160611)
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
