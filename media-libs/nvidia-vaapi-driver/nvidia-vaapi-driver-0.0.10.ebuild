# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A VA-API implemention using NVIDIA's NVDEC"
HOMEPAGE="https://github.com/elFarto/nvidia-vaapi-driver"
SRC_URI="https://github.com/elFarto/nvidia-vaapi-driver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/gst-plugins-bad
	media-libs/libglvnd
	>=media-libs/libva-1.8.0
	>=x11-libs/libdrm-2.4.60
"
DEPEND="${RDEPEND}
	>=media-libs/nv-codec-headers-11.1.5.1
"
BDEPEND="virtual/pkgconfig"

PATCHES="
	${FILESDIR}/nvidia-vaapi-driver-0.0.10-driverpath.patch
"
