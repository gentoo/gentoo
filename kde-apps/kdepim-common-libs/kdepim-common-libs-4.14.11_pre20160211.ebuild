# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMNOMODULE="true"
inherit kde4-meta

DESCRIPTION="Common libraries for KDE PIM apps"
COMMIT_ID="2aec255c6465676404e4694405c153e485e477d9"
SRC_URI="https://quickgit.kde.org/?p=kdepim.git&a=snapshot&h=${COMMIT_ID}&fmt=tgz -> ${KMNAME}-${PV}.tar.gz"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug google"

DEPEND="
	$(add_kdebase_dep baloo '' 4.14.3)
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)')
	app-crypt/gpgme
	>=app-office/akonadi-server-1.12.90
	dev-libs/grantlee:0
	google? ( net-libs/libkgapi:4 )
"
RDEPEND="${DEPEND}
	!kde-apps/libkdepim:4
	!kde-apps/libkleo:4
	!kde-apps/libkpgp:4
	!<kde-apps/kaddressbook-4.11.50:4
	!kde-apps/kdepim-wizards:4
	!<kde-apps/kmail-4.14.5:4
	!<kde-apps/korganizer-4.5.67:4
	$(add_kdeapps_dep kdepim-runtime)
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

PATCHES=(
	"${FILESDIR}/install-composereditorng.patch"
	"${FILESDIR}/${PN}-install-headers.patch"
)

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
