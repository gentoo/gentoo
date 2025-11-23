# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="NVIDIA wayland EGL external platform library, version 2"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland2/"
SRC_URI="
	https://github.com/NVIDIA/egl-wayland2/archive/refs/tags/v${PV/_/-}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-${PV/_/-}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/wayland[${MULTILIB_USEDEP}]
	media-libs/mesa[gbm(+),${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	>=dev-libs/wayland-protocols-1.38
	>=gui-libs/eglexternalplatform-1.2
	media-libs/libglvnd
"
BDEPEND="
	dev-util/wayland-scanner
"

pkg_postinst() {
	ewarn "gui-libs/egl-wayland2 is still experimental and will be used over"
	ewarn "gui-libs/egl-wayland(aka v1) if both are installed, please remember"
	ewarn "to try uninstalling v2 if experience issues."
}
