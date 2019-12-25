# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Qt-style client and server library wrapper for Wayland libraries"
HOMEPAGE="https://cgit.kde.org/kwayland.git"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[egl]
	>=dev-libs/wayland-1.15.0
	media-libs/mesa[egl]
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/wayland-protocols-1.15
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtwayland-${QTMIN}:5
"

# All failing, I guess we need a virtual wayland server
RESTRICT+=" test"

PATCHES=( "${FILESDIR}/${P}-qt-5.14.0.patch" )
