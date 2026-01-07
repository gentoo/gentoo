# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="NVIDIA wayland EGL external platform library, version 2"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland2/"

if [[ ${PV} == *_pre* ]]; then
	# happens often that nvidia-drivers ships with a (yet) unreleased
	# version and we need to ship a snapshot to provide the same fixes
	HASH_EGLWAYLAND2=6bbe588f21255222d8a149048a48f8b1091f12e5
	SRC_URI="
		https://github.com/NVIDIA/egl-wayland2/archive/${HASH_EGLWAYLAND2}.tar.gz
			-> ${P}.tar.gz
	"
	S=${WORKDIR}/${PN}-${HASH_EGLWAYLAND2}
else
	SRC_URI="
		https://github.com/NVIDIA/egl-wayland2/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
	"
fi

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
