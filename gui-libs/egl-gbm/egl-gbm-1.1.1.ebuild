# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="GBM EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-gbm/"
SRC_URI="https://github.com/NVIDIA/egl-gbm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	media-libs/mesa[gbm(+)]
	x11-libs/libdrm
	!<x11-drivers/nvidia-drivers-495.46-r20[wayland(-)]
"
DEPEND="
	${RDEPEND}
	gui-libs/eglexternalplatform
	media-libs/libglvnd
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-werror.patch
)

src_install() {
	meson_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/15_nvidia_gbm.json
}
