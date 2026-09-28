# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Common udev rules for ffmpeg and ffmpeg-compat with USE=soc"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S=${WORKDIR}

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	virtual/udev
"

src_install() {
	udev_newrules - 61-dma-heap-ffmpeg.rules <<-EOF
		SUBSYSTEM=="dma_heap", KERNEL=="linux,cma", GROUP="video", MODE="0660"
	EOF
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
