# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.3.0
QTMIN=6.7.1
inherit ecm flag-o-matic plasma.kde.org

DESCRIPTION="Qt-style API to interact with the wayland-client API"
HOMEPAGE="https://invent.kde.org/frameworks/kwayland"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# All failing, I guess we need a virtual wayland server
RESTRICT="test"

# slot ops: includes qpa/qplatformnativeinterface.h, surface_p.h
RDEPEND="
	>=dev-libs/wayland-1.15.0
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,gui,opengl]
	>=dev-qt/qtwayland-${QTMIN}:6=
	media-libs/libglvnd
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.13.0
	>=dev-libs/wayland-protocols-1.15
	sys-kernel/linux-headers
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	>=dev-util/wayland-scanner-1.19.0
"

src_configure() {
	filter-lto # bug 866575
	ecm_src_configure
}
