# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

HASH_EGLGBM=e5eee6058a812bce6df792c54efc484c4f15b6d1

DESCRIPTION="GBM EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-gbm/"
SRC_URI="https://github.com/NVIDIA/egl-gbm/archive/${HASH_EGLGBM}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HASH_EGLGBM}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	>=media-libs/mesa-21.2[gbm(+)]
	x11-libs/libdrm
	!<x11-drivers/nvidia-drivers-495.46-r20[wayland(-)]"
DEPEND="
	${RDEPEND}
	>=media-libs/libglvnd-1.3.4
	gui-libs/eglexternalplatform"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-werror.patch
)

src_install() {
	meson_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/15_nvidia_gbm.json
}
