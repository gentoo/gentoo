# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="optional"
ECM_HANDBOOK_DIR="docs"
ECM_TEST="forceoptional"
QTMIN=6.7.2
inherit ecm frameworks.kde.org xdg

DESCRIPTION="Framework providing transparent file and data management"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="acl +kwallet wayland X"

# tests hang
RESTRICT="test"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,ssl,widgets,X?]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kauth-${KDE_CATV}*:6
	=kde-frameworks/kbookmarks-${KDE_CATV}*:6
	=kde-frameworks/kcodecs-${KDE_CATV}*:6
	=kde-frameworks/kcolorscheme-${KDE_CATV}*:6
	=kde-frameworks/kcompletion-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kcrash-${KDE_CATV}*:6
	=kde-frameworks/kdbusaddons-${KDE_CATV}*:6
	=kde-frameworks/kguiaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kiconthemes-${KDE_CATV}*:6
	=kde-frameworks/kitemviews-${KDE_CATV}*:6
	=kde-frameworks/kjobwidgets-${KDE_CATV}*:6
	=kde-frameworks/knotifications-${KDE_CATV}*:6
	=kde-frameworks/kservice-${KDE_CATV}*:6
	=kde-frameworks/ktextwidgets-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	=kde-frameworks/kwindowsystem-${KDE_CATV}*:6[wayland?,X?]
	=kde-frameworks/kxmlgui-${KDE_CATV}*:6
	=kde-frameworks/solid-${KDE_CATV}*:6
	sys-power/switcheroo-control
	acl? (
		sys-apps/attr
		virtual/acl
	)
	handbook? (
		dev-libs/libxml2
		dev-libs/libxslt
		=kde-frameworks/karchive-${KDE_CATV}*:6
		=kde-frameworks/kdoctools-${KDE_CATV}*:6
	)
	kwallet? ( =kde-frameworks/kwallet-${KDE_CATV}*:6 )
	X? ( >=dev-qt/qtbase-${QTMIN}:6=[gui] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[libproxy]
	sys-power/switcheroo-control
"
# bug 944812: File Properties is accessible from KFileWidget (KIO); this
# provides access to keditfiletype binary via KWidgetsAddons (Tier1)
# Typical KIO revdeps (dolphin, krusader et al.) can rely on this dep
PDEPEND="
	>=kde-frameworks/kded-${KDE_CATV}:6
	kde-plasma/keditfiletype
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package acl ACL)
		$(cmake_use_find_package kwallet KF6Wallet)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
