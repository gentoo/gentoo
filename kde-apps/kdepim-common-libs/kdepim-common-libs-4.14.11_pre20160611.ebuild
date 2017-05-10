# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KMNOMODULE="true"
WEBKIT_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Common libraries for KDE PIM apps"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug google"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14.11_pre20160611)
	app-crypt/gpgme
	dev-libs/grantlee:0
	kde-apps/akonadi:4
	kde-frameworks/baloo:4
	google? ( $(add_kdeapps_dep libkgapi '' 2.2.0) )
"
RDEPEND="${DEPEND}
	!kde-apps/libkdepim:4
	!kde-apps/libkleo:4
	!kde-apps/libkpgp:4
	!<kde-apps/kaddressbook-4.11.50:4
	!kde-apps/kdepim-wizards:4
	!<kde-apps/kmail-4.14.5:4
	!<kde-apps/korganizer-4.5.67:4
	$(add_kdeapps_dep kdepim-runtime '' 4.14.11_pre20160211)
	app-crypt/gnupg
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

src_prepare() {
	kde4-meta_src_prepare
	sed -e '/folderarchiveagent.desktop/d' \
		-i agents/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package google LibKGAPI2)
	)

	kde4-meta_src_configure
}
