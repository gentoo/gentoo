# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

HASH_EGLWAYLAND=c10c5300483a8ec975e64e5d76c0fb00ac94e026

DESCRIPTION="EGLStream-based Wayland external platform"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland/"
SRC_URI="
	https://github.com/NVIDIA/egl-wayland/archive/${HASH_EGLWAYLAND}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-${HASH_EGLWAYLAND}

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
