# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for managing bookmarks stored in XBEL format"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	>=kde-frameworks/kcodecs-${PVCUT}:5
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/kiconthemes-${PVCUT}:5
	>=kde-frameworks/kwidgetsaddons-${PVCUT}:5
	>=kde-frameworks/kxmlgui-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kconfigwidgets-${PVCUT}:5
"
