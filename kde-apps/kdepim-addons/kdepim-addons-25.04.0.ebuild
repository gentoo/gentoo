# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.9.0
QTMIN=6.7.2
VIRTUALDBUS_TEST=1
inherit ecm gear.kde.org optfeature

DESCRIPTION="Plugins for KDE Personal Information Management Suite"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="activities importwizard markdown test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx,qt6]
	>=dev-libs/ktextaddons-1.5.4:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets,xml]
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-calendar-${PVCUT}:6
	>=kde-apps/akonadi-contacts-${PVCUT}:6
	>=kde-apps/calendarsupport-${PVCUT}:6
	>=kde-apps/grantleetheme-${PVCUT}:6
	>=kde-apps/incidenceeditor-${PVCUT}:6
	>=kde-apps/kaddressbook-${PVCUT}:6
	>=kde-apps/kcalutils-${PVCUT}:6
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kimap-${PVCUT}:6
	>=kde-apps/kitinerary-${PVCUT}:6
	>=kde-apps/kldap-${PVCUT}:6
	>=kde-apps/kmailtransport-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/kpimtextedit-${PVCUT}:6
	>=kde-apps/kpkpass-${PVCUT}:6
	>=kde-apps/libgravatar-${PVCUT}:6
	>=kde-apps/libkdepim-${PVCUT}:6
	>=kde-apps/libkleo-${PVCUT}:6
	>=kde-apps/libksieve-${PVCUT}:6
	>=kde-apps/libktnef-${PVCUT}:6
	>=kde-apps/mailcommon-${PVCUT}:6
	>=kde-apps/mailimporter-${PVCUT}:6
	>=kde-apps/messagelib-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6[activities?]
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6 )
	importwizard? ( >=kde-apps/akonadi-import-wizard-${PVCUT}:6 )
	markdown? ( app-text/discount:= )
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( sys-apps/dbus )"

src_configure() {
	local mycmakeargs=(
		# not packaged (bug 911819), but if present leads to rust shenanigans
		-DCMAKE_DISABLE_FIND_PACKAGE_Corrosion=ON # for adblock support, bug 940898
		-DCMAKE_DISABLE_FIND_PACKAGE_KLLMCore=ON # utilities/alpaka, not packaged
		-DOPTION_USE_PLASMA_ACTIVITIES=$(usex activities)
		$(cmake_use_find_package importwizard KPim6ImportWizard)
		$(cmake_use_find_package markdown Discount)
		-DKDEPIM_RUN_AKONADI_TEST=OFF # tests need database software and networking
	)

	ecm_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# Locale differences in date display.
		"fancyheaderstyleplugintest"
		"grantleeheaderstyleplugintest"
		# Comparison files outdated, also affected by changes in other packages.
		"messageviewerplugins-rendertest"
		# Tests pass but segfault when they exit.
		"kdepim-addons-eventedittest"
		"messageviewer-dkimauthenticationverifiedserverdialogtest"
		# Test pass but get stuck indefinetly afterwards.
		"kdepim-addons-todoedittest"
	)

	# tests can get stuck with spawned processes, 4 minutes is a reasonable timeout
	ecm_src_test --timeout $(( 60 * 4 )) # seconds
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "regex support for Sieve editor plugin" kde-misc/kregexpeditor
	fi
}
