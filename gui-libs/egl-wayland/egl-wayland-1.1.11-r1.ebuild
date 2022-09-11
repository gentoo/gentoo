# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="EGLStream-based Wayland external platform"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland"
SRC_URI="https://github.com/NVIDIA/egl-wayland/archive/refs/tags/${PV}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	dev-libs/wayland
	!<x11-drivers/nvidia-drivers-470.57.02[wayland(-)]"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
	gui-libs/eglexternalplatform
	>=media-libs/libglvnd-1.3.4
	x11-libs/libdrm"
BDEPEND="dev-util/wayland-scanner"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.6-remove-werror.patch
)

src_install() {
	meson_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/10_nvidia_wayland.json
}

pkg_postinst() {
	if has_version "<x11-drivers/nvidia-drivers-391"; then
		ewarn "<=nvidia-drivers-390.xx may not work properly with this version of"
		ewarn "egl-wayland, it is recommended to use nouveau drivers for wayland."
	fi
}
