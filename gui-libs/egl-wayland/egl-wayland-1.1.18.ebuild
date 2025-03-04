# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="NVIDIA wayland EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland/"
SRC_URI="
	https://github.com/NVIDIA/egl-wayland/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/wayland[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
	>=gui-libs/eglexternalplatform-1.1-r1
	media-libs/libglvnd
"
BDEPEND="
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.6-remove-werror.patch
)
