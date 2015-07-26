# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-common-libs/kdepim-common-libs-4.14.8.ebuild,v 1.4 2015/07/25 12:06:52 pacho Exp $

EAPI=5

KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMNOMODULE="true"
inherit kde4-meta

DESCRIPTION="Common libraries for KDE PIM apps"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/gpgme
	>=app-office/akonadi-server-1.12.90
	dev-libs/grantlee:0
	$(add_kdebase_dep baloo '' 4.14.3)
	$(add_kdebase_dep kdepimlibs)
"
RDEPEND="${DEPEND}
	!kde-base/akonadi:4
	!kde-base/libkdepim:4
	!kde-base/libkleo:4
	!kde-base/libkpgp:4
	!<kde-base/kaddressbook-4.11.50:4
	!kde-base/kdepim-wizards:4
	!<kde-base/kmail-4.14.5
	!<kde-base/korganizer-4.5.67:4
	app-crypt/gnupg
	$(add_kdebase_dep kdepim-runtime)
"

RESTRICT="test"
# bug 393131

KMEXTRA="
	agents/sendlateragent/
	akonadi_next/
	calendarsupport/
	calendarviews/
	composereditor-ng/
	grantleeeditor/grantleethemeeditor/
	grantleetheme/
	incidenceeditor-ng/
	libkdepim/
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
	kaddressbookgrantlee/
	kdgantt2/
	mailcommon/
	mailimporter/
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	noteshared/
	pimcommon/
	templateparser/
"
KMEXTRACTONLY="
	agents/mailfilteragent/org.freedesktop.Akonadi.MailFilterAgent.xml
	kleopatra/
	kmail/
	knode/org.kde.knode.xml
	korgac/org.kde.korganizer.KOrgac.xml
	korganizer/data/org.kde.korganizer.Korganizer.xml
	korganizer/data/org.kde.Korganizer.Calendar.xml
"
KMSAVELIBS="true"

PATCHES=( "${FILESDIR}/install-composereditorng.patch" )

src_prepare() {
	kde4-meta_src_prepare
	sed -e '/folderarchiveagent.desktop/d' \
		-i agents/CMakeLists.txt || die
}
