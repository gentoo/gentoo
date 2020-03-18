# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_QTHELP="false"
ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework binding JavaScript objects to QObjects"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

RDEPEND="
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kjs-${PVCUT}*:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
DEPEND="${RDEPEND}
	>=dev-qt/designer-${QTMIN}:5
"
