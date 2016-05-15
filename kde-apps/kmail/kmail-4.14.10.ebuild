# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
VIRTUALX_REQUIRED=test
inherit flag-o-matic kde4-meta

DESCRIPTION="Email component of Kontact, the integrated personal information manager of KDE"
HOMEPAGE="https://www.kde.org/applications/internet/kmail/"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)')
	$(add_kdeapps_dep korganizer)
	$(add_kdeapps_dep kdepim-common-libs)
"
RDEPEND="
	${DEPEND}
	!=kde-apps/kdepim-common-libs-4.12.1-r1
"

RESTRICT="test"
# bug 393147

KMEXTRACTONLY="
	agents/folderarchiveagent.desktop
	agents/sendlateragent/
	akonadi_next/
	calendarviews/
	grantleeeditor/grantleethemeeditor/
	kdgantt2/
	korganizer/
	kresources/
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
"
KMCOMPILEONLY="
	calendarsupport/
	grantleetheme/
	incidenceeditor-ng/
	kaddressbookgrantlee/
	mailcommon/
	mailimporter/
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	mailcommon/
	mailimporter/
	noteshared/
	pimcommon/
	templateparser/
"
KMEXTRA="
	agents/archivemailagent/
	agents/followupreminderagent/
	agents/mailfilteragent/
	grantleeeditor/headerthemeeditor/
	importwizard/
	kmailcvt/
	ksendemail/
	libksieve/
	mboximporter/
	pimsettingexporter/
	plugins/messageviewer/
"

KMLOADLIBS="kdepim-common-libs"

PATCHES=( "${FILESDIR}/kdepim-4.14.10-fix-cmake-3.4.patch" )

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	kde4-meta_src_configure
}

src_compile() {
	kde4-meta_src_compile kmail_xml
	kde4-meta_src_compile
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-apps/kdepim-kresources:${SLOT}"
		echo
	fi
	if ! has_version kde-apps/kleopatra:${SLOT}; then
		echo
		elog "For certificate management and the gnupg log viewer, please install kde-apps/kleopatra:${SLOT}"
		echo
	fi

	if has_version "app-office/akonadi-server[sqlite]"; then
		ewarn
		ewarn "We strongly recommend you set your Akonadi database backend to QMYSQL in your"
		ewarn "user configuration. This is the backend recommended by KDE upstream."
		ewarn "Reports indicate that kde-apps/kmail-4.10 does not work properly with the sqlite"
		ewarn "backend anymore."
		if has_version "app-office/akonadi-server[-mysql]"; then
			ewarn "FOR THAT, YOU WILL HAVE TO RE-BUILD app-office/akonadi-server WITH mysql USEFLAG ENABLED."
		fi
		ewarn "You can select the backend in your ~/.config/akonadi/akonadiserverrc."
		ewarn
	fi
}
