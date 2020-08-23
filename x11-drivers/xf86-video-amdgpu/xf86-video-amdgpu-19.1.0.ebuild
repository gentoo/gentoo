# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
XORG_DRI="always"
inherit xorg-3

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="amd64 ~ppc64 x86"
fi

DESCRIPTION="Accelerated Open Source driver for AMDGPU cards"

IUSE="udev"

RDEPEND=">=x11-libs/libdrm-2.4.89[video_cards_amdgpu]
	x11-base/xorg-server[-minimal]
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Fix-link-failure-with-gcc-10.patch
)

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--enable-glamor
		$(use_enable udev)
	)
}
