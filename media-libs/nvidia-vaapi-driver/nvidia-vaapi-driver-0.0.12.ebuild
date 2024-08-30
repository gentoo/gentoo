# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A VA-API implemention using NVIDIA's NVDEC"
HOMEPAGE="https://github.com/elFarto/nvidia-vaapi-driver"
SRC_URI="https://github.com/elFarto/nvidia-vaapi-driver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/gst-plugins-bad
	media-libs/libglvnd
	>=media-libs/libva-1.8.0
	>=x11-libs/libdrm-2.4.60"
DEPEND="${RDEPEND}
	>=media-libs/nv-codec-headers-11.1.5.1"
BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	# Source: https://github.com/elFarto/nvidia-vaapi-driver/blob/v0.0.12/src/backend-common.c#L13
	elog "If vaapi drivers fail to load, then make sure that you are"
	elog "passing the correct parameters to the kernel."
	elog "nvidia_drm.modeset should be set to 1."

	elog "Check the wiki page for more information: "
	elog "https://wiki.gentoo.org/wiki/VAAPI"
}
