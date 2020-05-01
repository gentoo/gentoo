# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.69.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Email client, supporting POP3 and IMAP mailboxes."
HOMEPAGE="https://kde.org/applications/office/org.kde.kmail2
https://kontact.kde.org/components/kmail.html"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64"
IUSE="telemetry"

# drop qtcore subslot operator when QT_MINIMAL >= 5.14.0
BDEPEND="
	dev-libs/libxslt
	test? ( >=kde-apps/akonadi-${PVCUT}:5[tools] )
"
COMMON_DEPEND="
	>=app-crypt/gpgme-1.11.1[cxx,qt5]
	>=dev-qt/qtcore-${QTMIN}:5=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-mime-${PVCUT}:5
	>=kde-apps/akonadi-search-${PVCUT}:5
	>=kde-apps/kdepim-apps-libs-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kontactinterface-${PVCUT}:5
	>=kde-apps/kpimtextedit-${PVCUT}:5
	>=kde-apps/libgravatar-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/libkleo-${PVCUT}:5
	>=kde-apps/libksieve-${PVCUT}:5
	>=kde-apps/libktnef-${PVCUT}:5
	>=kde-apps/mailcommon-${PVCUT}:5
	>=kde-apps/messagelib-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	telemetry? ( dev-libs/kuserfeedback:5 )
"
DEPEND="${COMMON_DEPEND}
	>=kde-apps/kcalutils-${PVCUT}:5
	>=kde-apps/kldap-${PVCUT}:5
	test? ( >=kde-apps/akonadi-${PVCUT}:5[sqlite] )
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kdepim-runtime-${PVCUT}:5
	>=kde-apps/kmail-account-wizard-${PVCUT}:5
"

RESTRICT+=" test" # bug 616878

src_prepare() {
	ecm_src_prepare

	if ! use handbook; then
		sed -i ktnef/CMakeLists.txt -e "/add_subdirectory(doc)/ s/^/#DONT/" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	pkg_is_installed() {
		echo "${1} ($(has_version ${1} || echo "not ")installed)"
	}

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
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
	fi
}
