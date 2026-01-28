# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="NVIDIA X11/XCB EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-x11/"

if [[ ${PV} == *_pre* ]]; then
	# happens often that nvidia-drivers ships with a (yet) unreleased
	# version and we need to ship a snapshot to provide the same fixes
	HASH_EGLX11=
	SRC_URI="
		https://github.com/NVIDIA/egl-x11/archive/${HASH_EGLX11}.tar.gz
			-> ${P}.tar.gz
	"
	S=${WORKDIR}/${PN}-${HASH_EGLX11}
else
	SRC_URI="
		https://github.com/NVIDIA/egl-x11/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
	"
fi

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"

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
