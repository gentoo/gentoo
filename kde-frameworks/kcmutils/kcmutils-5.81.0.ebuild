# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework to work with KDE System Settings modules"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kauth-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kdeclarative-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kxmlgui-${PVCUT}*:5
"
RDEPEND="${DEPEND}"
