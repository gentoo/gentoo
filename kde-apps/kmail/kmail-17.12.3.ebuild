# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Email client, supporting POP3 and IMAP mailboxes."
HOMEPAGE="https://www.kde.org/applications/internet/kmail/"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="~amd64 ~x86"
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
	$(add_kdeapps_dep libktnef)
	$(add_kdeapps_dep mailcommon)
	$(add_kdeapps_dep messagelib)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=app-crypt/gpgme-1.7.1[cxx,qt5]
"
DEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kldap)
	dev-libs/libxslt
	test? ( $(add_kdeapps_dep akonadi 'sqlite,tools') )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-common-libs:4
	!kde-apps/kdepim-l10n
	!kde-apps/ktnef
	$(add_kdeapps_dep kdepim-runtime)
	$(add_kdeapps_dep kmail-account-wizard)
"

RESTRICT+=" test" # bug 616878

src_prepare() {
	cmake-utils_src_prepare

	if ! use handbook; then
		sed -i ktnef/CMakeLists.txt -e "/add_subdirectory(doc)/ s/^/#DONT/" || die
	fi
}

pkg_postinst() {
	kde5_pkg_postinst

	pkg_is_installed() {
		echo "${1} ($(has_version ${1} || echo "not ")installed)"
	}

	elog "KMail supports the following runtime dependencies:"
	elog "  Virus detection:"
	elog "    $(pkg_is_installed app-antivirus/clamav)"
	elog "  Spam filtering:"
	elog "    $(pkg_is_installed mail-filter/bogofilter)"
	elog "    $(pkg_is_installed mail-filter/spamassassin)"
	elog "  Fancy e-mail headers and various useful plugins:"
	elog "    $(pkg_is_installed kde-apps/kdepim-addons:${SLOT})"
	elog "  Crypto config and certificate details GUI:"
	elog "    $(pkg_is_installed kde-apps/kleopatra:${SLOT})"
}
