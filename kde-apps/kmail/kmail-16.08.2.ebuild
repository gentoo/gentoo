# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
KMNAME="kdepim"
QT_MINIMAL="5.7.0"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Email client, supporting POP3 and IMAP mailboxes."
HOMEPAGE="https://www.kde.org/applications/internet/kmail/"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-contacts)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep akonadi-search)
	$(add_kdeapps_dep gpgmepp)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kdepim-apps-libs)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep kontactinterface)
	$(add_kdeapps_dep kpimtextedit)
	$(add_kdeapps_dep libgravatar)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkleo)
	$(add_kdeapps_dep libksieve)
	$(add_kdeapps_dep mailcommon)
	$(add_kdeapps_dep messagelib)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
DEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kldap)
	dev-libs/boost:=
	dev-libs/libxslt
	test? ( $(add_kdeapps_dep akonadi 'sqlite,tools') )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim:5
	!kde-apps/kdepim-common-libs:4
"

src_prepare() {
	# kmail subproject does not contain doc
	# at least until properly split upstream
	echo "add_subdirectory(doc)" >> CMakeLists.txt || die "Failed to add doc dir"

	mkdir doc || die "Failed to create doc dir"
	mv ../doc/${PN} doc || die "Failed to move handbook"
	mv ../doc/akonadi_archivemail_agent doc || die "Failed to move handbook"
	mv ../doc/akonadi_followupreminder_agent doc || die "Failed to move handbook"
	mv ../doc/akonadi_sendlater_agent doc || die "Failed to move handbook"
	cat <<-EOF > doc/CMakeLists.txt
add_subdirectory(${PN})
add_subdirectory(akonadi_archivemail_agent)
add_subdirectory(akonadi_followupreminder_agent)
add_subdirectory(akonadi_sendlater_agent)
EOF

	kde5_src_prepare
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version "kde-apps/kdepim-addons:${SLOT}" ; then
		echo
		elog "Install kde-apps/kdepim-addons:${SLOT} for fancy e-mail headers and various useful plugins."
		echo
	fi

	if ! has_version "kde-apps/kleopatra:${SLOT}" ; then
		echo
		elog "Install kde-apps/kleopatra:${SLOT} to get a crypto config and certificate details GUI."
		echo
	fi
}
