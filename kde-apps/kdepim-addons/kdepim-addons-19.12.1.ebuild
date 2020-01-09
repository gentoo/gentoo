# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_EXAMPLES="true"
ECM_TEST="forceoptional-recursive"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Plugins for KDE Personal Information Management Suite"
HOMEPAGE="https://kde.org/applications/office/org.kde.kontact"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="importwizard markdown"

# drop qtwidgets subslot operator when QT_MINIMAL >= 5.14.0
COMMON_DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5=
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-notes-${PVCUT}:5
	>=kde-apps/calendarsupport-${PVCUT}:5
	>=kde-apps/eventviews-${PVCUT}:5
	>=kde-apps/grantleetheme-${PVCUT}:5
	>=kde-apps/incidenceeditor-${PVCUT}:5
	>=kde-apps/kdepim-apps-libs-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kimap-${PVCUT}:5
	>=kde-apps/kitinerary-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kontactinterface-${PVCUT}:5
	>=kde-apps/kpkpass-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/libkleo-${PVCUT}:5
	>=kde-apps/libksieve-${PVCUT}:5
	>=kde-apps/libktnef-${PVCUT}:5
	>=kde-apps/mailcommon-${PVCUT}:5
	>=kde-apps/messagelib-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/prison-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	importwizard? ( >=kde-apps/akonadi-import-wizard-${PVCUT}:5 )
	markdown? ( app-text/discount )
"
DEPEND="${COMMON_DEPEND}
	>=app-crypt/gpgme-1.11.1[cxx,qt5]
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kaddressbook:4
	!kde-apps/kdepim-l10n
	!kde-apps/kmail:4
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DKDEPIMADDONS_BUILD_EXAMPLES=$(usex examples)
		$(cmake_use_find_package importwizard KPimImportWizard)
		$(cmake_use_find_package markdown Discount)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ ${KDE_BUILD_TYPE} = live ]] && ! has_version "kde-misc/kregexpeditor" ; then
		elog "${PN} Sieve editor plugin can make use of kde-misc/kregexpeditor if installed."
	fi
}
