# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="optional"
ECM_HANDBOOK_DIR="docs"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org xdg-utils

DESCRIPTION="Framework providing transparent file and data management"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="acl +kwallet wayland X"

# tests hang
RESTRICT="test"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,ssl,widgets]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kauth-${PVCUT}*:6
	=kde-frameworks/kbookmarks-${PVCUT}*:6
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kcolorscheme-${PVCUT}*:6
	=kde-frameworks/kcompletion-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kconfigwidgets-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kcrash-${PVCUT}*:6
	=kde-frameworks/kdbusaddons-${PVCUT}*:6
	=kde-frameworks/kguiaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kiconthemes-${PVCUT}*:6
	=kde-frameworks/kitemviews-${PVCUT}*:6
	=kde-frameworks/kjobwidgets-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/ktextwidgets-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	=kde-frameworks/kwindowsystem-${PVCUT}*:6[wayland?,X?]
	=kde-frameworks/kxmlgui-${PVCUT}*:6
	=kde-frameworks/solid-${PVCUT}*:6
	sys-power/switcheroo-control
	acl? (
		sys-apps/attr
		virtual/acl
	)
	handbook? (
		dev-libs/libxml2
		dev-libs/libxslt
		=kde-frameworks/karchive-${PVCUT}*:6
		=kde-frameworks/kdoctools-${PVCUT}*:6
	)
	kwallet? ( =kde-frameworks/kwallet-${PVCUT}*:6 )
	X? ( >=dev-qt/qtbase-${QTMIN}:6=[gui] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[libproxy]
	sys-power/switcheroo-control
"
PDEPEND=">=kde-frameworks/kded-${PVCUT}:6"

PATCHES=( "${FILESDIR}/${P}-remove-parent-for-DropMenu.patch" ) # KDE-bug 490183

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package acl ACL)
		$(cmake_use_find_package kwallet KF6Wallet)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	xdg_desktop_database_update
}

pkg_postrm() {
	ecm_pkg_postrm
	xdg_desktop_database_update
}
