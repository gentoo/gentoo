# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="Style for QtQuickControls 2 that uses QWidget's QStyle for painting"

LICENSE="|| ( GPL-2+ LGPL-3+ )"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kirigami-${PVCUT}*:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"

PATCHES=( "${FILESDIR}"/${P}-move-dbus-connection-in-singleton.patch )
