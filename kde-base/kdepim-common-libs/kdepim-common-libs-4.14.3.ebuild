# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-common-libs/kdepim-common-libs-4.14.3.ebuild,v 1.6 2015/02/17 11:06:46 ago Exp $

EAPI=5

KMNAME="kdepim"
KMNOMODULE="true"
inherit kde4-meta

DESCRIPTION="Common libraries for KDE PIM apps"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/gpgme
	>=app-office/akonadi-server-1.12.90
	dev-libs/grantlee:0
	$(add_kdebase_dep baloo)
	$(add_kdebase_dep kdepimlibs)
"
RDEPEND="${DEPEND}
	!kde-base/akonadi:4
	!kde-base/libkdepim:4
	!kde-base/libkleo:4
	!kde-base/libkpgp:4
	!<kde-base/kaddressbook-4.11.50:4
	!kde-base/kdepim-wizards:4
	!<kde-base/kmail-4.4.80:4
	!=kde-base/kmail-4.11*
	!=kde-base/kmail-4.12.0
	!=kde-base/kmail-4.12.1
	!<kde-base/kmail-4.13.60
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
	kaddressbookgrantlee/
	incidenceeditor-ng/
	libkdepim/
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
	kdgantt2/
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	noteshared/
	pimcommon/
	templateparser/
"
KMEXTRACTONLY="
	kleopatra/
	kmail/
	knode/org.kde.knode.xml
	korgac/org.kde.korganizer.KOrgac.xml
	korganizer/org.kde.korganizer.Korganizer.xml
	mailcommon/
"
KMSAVELIBS="true"

PATCHES=( "${FILESDIR}/install-composereditorng.patch" )

src_prepare() {
	kde4-meta_src_prepare
	sed -e '/folderarchiveagent.desktop/d' \
		-i agents/CMakeLists.txt || die
}
