# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.92.0
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.4
inherit ecm plasma.kde.org

DESCRIPTION="Wayland Server Components built on KDE Frameworks"
HOMEPAGE="https://invent.kde.org/plasma/kwayland-server"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

# All failing, I guess we need a virtual wayland server
RESTRICT="test"

RDEPEND="
	>=dev-libs/wayland-1.19.0
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[egl]
	>=dev-qt/qtwayland-${QTMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	media-libs/libglvnd
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.6.0
	>=dev-libs/wayland-protocols-1.24
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	dev-util/wayland-scanner
"
