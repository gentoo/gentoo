# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson-multilib toolchain-funcs

# no releases yet, should typically update hash in sync with nvidia bumps
HASH_EGLX11=8aac36c712561ebfecc82af3db15c50cd0d573fb

DESCRIPTION="NVIDIA X11/XCB EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-x11/"
SRC_URI="
	https://github.com/NVIDIA/egl-x11/archive/${HASH_EGLX11}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-${HASH_EGLX11}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# wrt blocker, may or may not cause problems if present with <560
# drivers, and collides with <565.57.01-r2
RDEPEND="
	media-libs/mesa[gbm(+),${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	!<x11-drivers/nvidia-drivers-565.57.01-r2
"
DEPEND="
	${RDEPEND}
	>=gui-libs/eglexternalplatform-1.2
	media-libs/libglvnd
	x11-base/xorg-proto
"

src_configure() {
	# needs looking into, likely some UB broken at >=-O1 (bug #942396)
	tc-is-clang && replace-flags '-O*' '-O0'

	meson-multilib_src_configure
}
