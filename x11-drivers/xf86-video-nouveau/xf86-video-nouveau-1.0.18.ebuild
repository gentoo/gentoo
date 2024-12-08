# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DRI="always"
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="
	https://nouveau.freedesktop.org/
	https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau
"

KEYWORDS="~amd64 ~arm64 ~loong ppc ~ppc64 ~riscv x86"

RDEPEND=">=x11-libs/libdrm-2.4.60[video_cards_nouveau]
	virtual/libudev:="
DEPEND="${RDEPEND}"
