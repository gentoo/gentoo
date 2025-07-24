# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_QTHELP="true"
ECM_TEST="forceoptional"
KFMIN=6.13.0
QTMIN=6.7.2
VIRTUALDBUS_TEST="true"
inherit ecm gear.kde.org xdg

DESCRIPTION="Storage service for PIM data and libraries for PIM apps"
HOMEPAGE="https://community.kde.org/KDE_PIM/akonadi"

LICENSE="LGPL-2.1+"
SLOT="6/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm64"
IUSE="tools +webengine xml"

REQUIRED_USE="test? ( tools )"

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT="test"

COMMON_DEPEND="
	app-arch/xz-utils
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets,xml]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	webengine? (
		kde-apps/kaccounts-integration:6
		>=net-libs/accounts-qt-1.17[qt6(+)]
	)
	xml? ( dev-libs/libxml2:= )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	test? ( sys-apps/dbus )
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/akonadi-config
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=$(usex tools)
		$(cmake_use_find_package webengine AccountsQt6)
		$(cmake_use_find_package webengine KAccounts6)
		$(cmake_use_find_package xml LibXml2)
	)

	ecm_src_configure
}
