# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="QEMU QXL paravirt video driver"

KEYWORDS="amd64 x86"

RDEPEND="
	x11-base/xorg-server[-minimal]
	>=x11-libs/libdrm-2.4.46"
DEPEND="${RDEPEND}
	>=app-emulation/spice-protocol-0.12.0
	x11-base/xorg-proto"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		--disable-xspice
	)
	xorg-2_src_configure
}
