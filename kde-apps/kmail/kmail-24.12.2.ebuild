# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org optfeature

DESCRIPTION="Email client, supporting POP3 and IMAP mailboxes"
HOMEPAGE="https://apps.kde.org/kmail2/
https://kontact.kde.org/components/kmail/"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="activities pch speech telemetry"

RESTRICT="test" # bug 616878

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
COMMON_DEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx,qt6]
	>=dev-libs/ktextaddons-1.5.4:6[speech?]
	>=dev-libs/libgpg-error-1.36
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-contacts-${PVCUT}:6
	>=kde-apps/akonadi-mime-${PVCUT}:6
	>=kde-apps/akonadi-search-${PVCUT}:6
	>=kde-apps/kcalutils-${PVCUT}:6
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kldap-${PVCUT}:6
	>=kde-apps/kmailtransport-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/kontactinterface-${PVCUT}:6
	>=kde-apps/kpimtextedit-${PVCUT}:6[speech=]
	>=kde-apps/libgravatar-${PVCUT}:6
	>=kde-apps/libkdepim-${PVCUT}:6
	>=kde-apps/libkleo-${PVCUT}:6
	>=kde-apps/libksieve-${PVCUT}:6
	>=kde-apps/libktnef-${PVCUT}:6
	>=kde-apps/mailcommon-${PVCUT}:6
	>=kde-apps/messagelib-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6[activities?]
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6 )
	telemetry? ( >=kde-frameworks/kuserfeedback-${KFMIN}:6 )
"
DEPEND="${COMMON_DEPEND}
	>=kde-apps/kcalutils-${PVCUT}:6
	>=kde-apps/kldap-${PVCUT}:6
	test? ( kde-apps/akonadi-config[sqlite] )
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kdepim-runtime-${PVCUT}:6
	>=kde-apps/kmail-account-wizard-${PVCUT}:6
"
BDEPEND="
	dev-libs/libxslt
	test? ( >=kde-apps/akonadi-${PVCUT}:6[tools] )
"

src_prepare() {
	ecm_src_prepare
	use handbook || cmake_run_in ktnef cmake_comment_add_subdirectory doc
}

src_configure() {
	local mycmakeargs=(
		-DOPTION_USE_PLASMA_ACTIVITIES=$(usex activities)
		-DUSE_PRECOMPILED_HEADERS=$(usex pch)
		$(cmake_use_find_package speech KF6TextEditTextToSpeech)
		$(cmake_use_find_package telemetry KF6UserFeedback)
	)

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "virus detection" app-antivirus/clamav
		optfeature "spam filtering" mail-filter/bogofilter mail-filter/spamassassin
		optfeature "fancy e-mail headers and useful plugins" "kde-apps/kdepim-addons:${SLOT}"
		optfeature "crypto config and certificate details GUI" "kde-apps/kleopatra:${SLOT}"
		optfeature "import PIM data from other applications" "kde-apps/akonadi-import-wizard:${SLOT}"
	fi
	ecm_pkg_postinst
}
