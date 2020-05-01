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

DESCRIPTION="Address book application based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/office/org.kde.kaddressbook"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="~amd64 ~arm64"
IUSE="telemetry"

DEPEND="
	>=app-crypt/gpgme-1.11.1[cxx,qt5]
	dev-libs/grantlee:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-search-${PVCUT}:5
	>=kde-apps/grantleetheme-${PVCUT}:5
	>=kde-apps/kdepim-apps-libs-${PVCUT}:5
	>=kde-apps/kontactinterface-${PVCUT}:5
	>=kde-apps/libgravatar-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/libkleo-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/prison-${KFMIN}:5
	telemetry? ( dev-libs/kuserfeedback:5 )
"
RDEPEND="${DEPEND}
	>=kde-apps/kdepim-runtime-${PVCUT}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		has_version "kde-apps/kdepim-addons:${SLOT}" || \
			elog "${PN} is not complete without kde-apps/kdepim-addons:${SLOT}!"
	fi
}
