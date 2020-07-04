# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI=always
inherit linux-info xorg-3

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="ATI video driver"
HOMEPAGE="https://www.x.org/wiki/ati/"

IUSE="udev"

RDEPEND=">=x11-libs/libdrm-2.4.89[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	x11-base/xorg-server[-minimal]
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--enable-glamor
		$(use_enable udev)
	)
}
