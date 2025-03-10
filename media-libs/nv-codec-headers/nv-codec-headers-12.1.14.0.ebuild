# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# do not stabilize without a matching stable nvidia-drivers version
NV_MIN_VERSION=530.41.03 # see README

DESCRIPTION="FFmpeg version of headers required to interface with Nvidias codec APIs"
HOMEPAGE="https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git"
SRC_URI="https://github.com/FFmpeg/nv-codec-headers/releases/download/n${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR=share install
	einstalldocs
}

pkg_postinst() {
	if ! has_version ">=x11-drivers/nvidia-drivers-${NV_MIN_VERSION}"; then
		ewarn
		ewarn "Be warned that packages built using this version of ${PN}"
		ewarn "will require x11-drivers/nvidia-drivers of version ${NV_MIN_VERSION} or"
		ewarn "higher for NVDEC/NVENC to function properly. If switch to an older"
		ewarn "${PN} version, remember to rebuild packages that are using"
		ewarn "this such as ffmpeg or mpv."
	fi
}
