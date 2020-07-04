# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Provides integration plugins for various KDE frameworks for Wayland"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-integration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}"

RESTRICT+=" test" # bug 668872
