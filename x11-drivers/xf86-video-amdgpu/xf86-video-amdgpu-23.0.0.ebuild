# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
XORG_DRI="always"
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"
fi

DESCRIPTION="Accelerated Open Source driver for AMDGPU cards"

IUSE="udev"

RDEPEND=">=x11-libs/libdrm-2.4.89[video_cards_amdgpu]
	x11-base/xorg-server[-minimal]
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--enable-glamor
		$(use_enable udev)
	)
	xorg-3_src_configure
}
