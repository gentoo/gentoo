# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org optfeature

DESCRIPTION="Email client, supporting POP3 and IMAP mailboxes"
HOMEPAGE="https://apps.kde.org/kmail2/
https://kontact.kde.org/components/kmail/"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE="pch speech telemetry"

RESTRICT="test" # bug 616878

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
COMMON_DEPEND="
	>=app-crypt/gpgme-1.16.0:=[cxx,qt5]
	dev-libs/ktextaddons:5[speech?]
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-mime-${PVCUT}:5
	>=kde-apps/akonadi-search-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kontactinterface-${PVCUT}:5
	>=kde-apps/kpimtextedit-${PVCUT}:5[speech=]
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
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	telemetry? ( >=dev-libs/kuserfeedback-1.2.0:5 )
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
BDEPEND="
	dev-libs/libxslt
	test? ( >=kde-apps/akonadi-${PVCUT}:5[tools] )
"

src_prepare() {
	ecm_src_prepare
	use handbook || cmake_run_in ktnef cmake_comment_add_subdirectory doc
}

src_configure() {
	local mycmakeargs=(
		-DUSE_PRECOMPILED_HEADERS=$(usex pch)
		$(cmake_use_find_package speech KF5TextEditTextToSpeech)
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "virus detection" app-antivirus/clamav
		optfeature "spam filtering" mail-filter/bogofilter mail-filter/spamassassin
		optfeature "fancy e-mail headers and useful plugins" kde-apps/kdepim-addons:${SLOT}
		optfeature "crypto config and certificate details GUI" kde-apps/kleopatra:${SLOT}
		optfeature "import PIM data from other applications" kde-apps/akonadi-import-wizard:${SLOT}
	fi
	ecm_pkg_postinst
}
