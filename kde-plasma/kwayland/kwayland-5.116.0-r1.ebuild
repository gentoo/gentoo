# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
inherit ecm flag-o-matic frameworks.kde.org

DESCRIPTION="Qt-style client and server library wrapper for Wayland libraries"
HOMEPAGE="https://invent.kde.org/frameworks/kwayland"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"
IUSE=""

# All failing, I guess we need a virtual wayland server
RESTRICT="test"

# slot ops: includes qpa/qplatformnativeinterface.h, surface_p.h
RDEPEND="
	dev-libs/wayland
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5=[egl]
	dev-qt/qtwayland:5=
	media-libs/libglvnd
"
DEPEND="${RDEPEND}
	>=dev-libs/plasma-wayland-protocols-1.9.0
	dev-libs/wayland-protocols
	sys-kernel/linux-headers
"
BDEPEND="
	dev-qt/qtwaylandscanner:5
	dev-util/wayland-scanner
"

# Pending upstream MR: https://invent.kde.org/plasma/kwayland/-/merge_requests/128
PATCHES=( "${FILESDIR}/${P}-no-server.patch" ) # bug 949197

src_configure() {
	filter-lto # bug 866575
	local mycmakeargs=( -DEXCLUDE_DEPRECATED_BEFORE_AND_AT=5.74.0 )
	ecm_src_configure
}
