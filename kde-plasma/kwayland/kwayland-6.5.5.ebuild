# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm flag-o-matic plasma.kde.org

DESCRIPTION="Qt-style API to interact with the wayland-client API"
HOMEPAGE="https://invent.kde.org/frameworks/kwayland"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv ~x86"
IUSE=""

# All failing, I guess we need a virtual wayland server
RESTRICT="test"

# slot ops: includes qpa/qplatformnativeinterface.h, surface_p.h
RDEPEND="
	>=dev-libs/wayland-1.15.0
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,gui,opengl,wayland]
	media-libs/libglvnd
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.19.0
	>=dev-libs/wayland-protocols-1.15
	sys-kernel/linux-headers
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	>=dev-util/wayland-scanner-1.19.0
"

src_configure() {
	filter-lto # bug 866575
	ecm_src_configure
}
