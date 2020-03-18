# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for embedding scripting into applications"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

RDEPEND="
	=kde-frameworks/kcompletion-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kparts-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kxmlgui-${PVCUT}*:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
DEPEND="${RDEPEND}
	>=dev-qt/designer-${QTMIN}:5
"
