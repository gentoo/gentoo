# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.70.0
PVCUT=$(ver_cut 1-2)
QTMIN=5.14.1
inherit ecm kde.org

DESCRIPTION="Wayland Server Components built on KDE Frameworks"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-server"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE=""

RDEPEND="
	>=dev-libs/wayland-1.15.0
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[egl]
	>=dev-qt/qtwayland-${QTMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	media-libs/mesa[egl]
"
DEPEND="${RDEPEND}
	dev-libs/plasma-wayland-protocols
	>=dev-libs/wayland-protocols-1.15
"

# All failing, I guess we need a virtual wayland server
RESTRICT+=" test"
