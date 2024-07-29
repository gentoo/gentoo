# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="EGLStream-based Wayland external platform"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland/"
SRC_URI="
	https://github.com/NVIDIA/egl-wayland/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/wayland
	x11-libs/libdrm
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
	gui-libs/eglexternalplatform
	media-libs/libglvnd
"
BDEPEND="
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.6-remove-werror.patch
)

src_install() {
	meson_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/10_nvidia_wayland.json
}
