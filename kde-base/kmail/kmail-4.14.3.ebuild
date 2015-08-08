# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kdepim"
VIRTUALX_REQUIRED=test
inherit flag-o-matic kde4-meta

DESCRIPTION="KMail is the email component of Kontact, the integrated personal information manager of KDE"
HOMEPAGE="http://www.kde.org/applications/internet/kmail/"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep korganizer)
	$(add_kdebase_dep kdepim-common-libs "" 4.12.1-r2)
"
RDEPEND="
	${DEPEND}
	!=kde-base/kdepim-common-libs-4.12.1-r1
"

RESTRICT="test"
# bug 393147

KMEXTRACTONLY="
	agents/folderarchiveagent.desktop
	agents/sendlateragent/
	akonadi_next/
	calendarsupport/
	calendarviews/
	grantleeeditor/grantleethemeeditor/
	korganizer/
	kresources/
	libkleo/
	libkpgp/
	libkdepimdbusinterfaces/
	kdgantt2/
"
KMCOMPILEONLY="
	grantleetheme/
	kaddressbookgrantlee/
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	pimcommon/
	templateparser/
	incidenceeditor-ng/
	calendarsupport/
	noteshared/
"
KMEXTRA="
	agents/archivemailagent/
	agents/followupreminderagent/
	agents/mailfilteragent/
	grantleeeditor/headerthemeeditor/
	kmailcvt/
	ksendemail/
	importwizard/
	libksieve/
	mailcommon/
	mailimporter/
	mboximporter/
	pimsettingexporter/
	plugins/messageviewer/
"

KMLOADLIBS="kdepim-common-libs"

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

	if ! has_version kde-base/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-base/kdepim-kresources:${SLOT}"
		echo
	fi
	if ! has_version kde-base/kleopatra:${SLOT}; then
		echo
		elog "For certificate management and the gnupg log viewer, please install kde-base/kleopatra:${SLOT}"
		echo
	fi

	if has_version "app-office/akonadi-server[sqlite]"; then
		ewarn
		ewarn "We strongly recommend you set your Akonadi database backend to QMYSQL in your"
		ewarn "user configuration. This is the backend recommended by KDE upstream."
		ewarn "Reports indicate that kde-base/kmail-4.10 does not work properly with the sqlite"
		ewarn "backend anymore."
		if has_version "app-office/akonadi-server[-mysql]"; then
			ewarn "FOR THAT, YOU WILL HAVE TO RE-BUILD app-office/akonadi-server WITH mysql USEFLAG ENABLED."
		fi
		ewarn "You can select the backend in your ~/.config/akonadi/akonadiserverrc."
		ewarn
	fi
}
