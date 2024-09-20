# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="GBM EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-gbm/"
SRC_URI="
	https://github.com/NVIDIA/egl-gbm/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	media-libs/mesa[gbm(+),${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	>=gui-libs/eglexternalplatform-1.1-r1
	media-libs/libglvnd
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-werror.patch
)

src_install() {
	meson-multilib_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/15_nvidia_gbm.json
}
