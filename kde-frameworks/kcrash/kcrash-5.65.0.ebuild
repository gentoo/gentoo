# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for intercepting and handling application crashes"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

# requires running kde environment
RESTRICT+=" test"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/kwindowsystem-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"
