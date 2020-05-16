# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Qt-style client and server library wrapper for Wayland libraries"
HOMEPAGE="https://invent.kde.org/frameworks/kwayland"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

RDEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[egl]
	>=dev-qt/qtwayland-${QTMIN}:5
	>=dev-libs/wayland-1.15.0
	media-libs/mesa[egl]
"
DEPEND="${RDEPEND}
	>=dev-libs/wayland-protocols-1.15
"

# All failing, I guess we need a virtual wayland server
RESTRICT+=" test"
