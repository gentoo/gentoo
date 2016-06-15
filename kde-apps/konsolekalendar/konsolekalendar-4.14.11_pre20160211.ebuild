# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="A command line interface to KDE calendars"
HOMEPAGE+=" https://userbase.kde.org/KonsoleKalendar"
COMMIT_ID="2aec255c6465676404e4694405c153e485e477d9"
SRC_URI="https://quickgit.kde.org/?p=kdepim.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${KMNAME}-${PV}.tar.gz"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)')
	$(add_kdeapps_dep kdepim-common-libs)
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
