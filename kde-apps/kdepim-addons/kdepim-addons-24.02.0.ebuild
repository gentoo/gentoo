# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0
QTMIN=6.6.2
inherit ecm gear.kde.org optfeature

DESCRIPTION="Plugins for KDE Personal Information Management Suite"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64"
IUSE="importwizard markdown"

RESTRICT="test"

RDEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx,qt6]
	dev-libs/ktextaddons:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets,xml]
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-contacts-${PVCUT}:6
	>=kde-apps/akonadi-notes-${PVCUT}:6
	>=kde-apps/calendarsupport-${PVCUT}:6
	>=kde-apps/eventviews-${PVCUT}:6
	>=kde-apps/grantleetheme-${PVCUT}:6
	>=kde-apps/incidenceeditor-${PVCUT}:6
	>=kde-apps/kaddressbook-${PVCUT}:6
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kimap-${PVCUT}:6
	>=kde-apps/kitinerary-${PVCUT}:6
	>=kde-apps/kmailtransport-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/kpkpass-${PVCUT}:6
	>=kde-apps/libkdepim-${PVCUT}:6
	>=kde-apps/libkleo-${PVCUT}:6
	>=kde-apps/libksieve-${PVCUT}:6
	>=kde-apps/libktnef-${PVCUT}:6
	>=kde-apps/mailcommon-${PVCUT}:6
	>=kde-apps/messagelib-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	importwizard? ( >=kde-apps/akonadi-import-wizard-${PVCUT}:6 )
	markdown? ( app-text/discount:= )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package importwizard KPimImportWizard)
		$(cmake_use_find_package markdown Discount)
	)

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "regex support for Sieve editor plugin" kde-misc/kregexpeditor
	fi
	ecm_pkg_postinst
}
