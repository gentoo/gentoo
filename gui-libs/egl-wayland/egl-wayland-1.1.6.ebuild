# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson

DESCRIPTION="EGLStream-based Wayland external platform (for NVIDIA)"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland"
SRC_URI="https://github.com/NVIDIA/egl-wayland/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/wayland
	!x11-drivers/nvidia-drivers[wayland(-)]"
DEPEND="
	${RDEPEND}
	gui-libs/eglexternalplatform
	media-libs/libglvnd"
BDEPEND="dev-util/wayland-scanner"

PATCHES=(
	"${FILESDIR}"/${P}-remove-werror.patch
)

src_configure() {
	# EGLStream is not intended for X11, always build without (bug #777558)
	append-cppflags -DEGL_NO_X11

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/10_nvidia_wayland.json
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To use EGLStream with x11-drivers/nvidia-drivers, it is necessary to"
		elog "load the nvidia-drm module with experimental nvidia-drm.modeset=1."
		elog
		elog "Can be accomplished by:"
		elog "  echo 'options nvidia-drm modeset=1' > ${EROOT}/etc/modprobe.d/nvidia-drm.conf"
		elog "...then reloading the module."
	fi
}
