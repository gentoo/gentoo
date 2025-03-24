# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ideally only stabilize versions that work for all non-masked nvidia-drivers
NV_MIN_VERSION=550.54.14 # see README

DESCRIPTION="FFmpeg version of headers required to interface with Nvidias codec APIs"
HOMEPAGE="https://git.videolan.org/?p=ffmpeg/nv-codec-headers.git"
SRC_URI="https://github.com/FFmpeg/nv-codec-headers/releases/download/n${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR=share install
	einstalldocs
}

pkg_postinst() {
	# prefer not to depend on nvidia-drivers given this package is depended
	# on as header-only and drivers are optfeature'ish which can be better
	# for e.g. binhosts to provide support (binding operators also not really
	# suitable in DEPEND-only wrt rebuilds, rebuilds are not currently needed
	# to work with *newer* drivers, and would be annoying for users switching
	# driver versions only to troubleshoot non-nvenc issues)
	if ! has_version ">=x11-drivers/nvidia-drivers-${NV_MIN_VERSION}"; then
		ewarn
		ewarn "Be warned that packages built using this version of ${PN}"
		ewarn "will require x11-drivers/nvidia-drivers of version ${NV_MIN_VERSION} or"
		ewarn "higher for NVDEC/NVENC to function properly. If switch to an older"
		ewarn "${PN} version, remember to rebuild packages that are using"
		ewarn "this such as ffmpeg or mpv."
	fi
}
