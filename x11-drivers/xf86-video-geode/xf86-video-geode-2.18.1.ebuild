# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="AMD Geode GX and LX graphics driver"
KEYWORDS="~x86"
IUSE="ztv"

DEPEND="
	ztv? (
		sys-kernel/linux-headers
	)
"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable ztv)
	)
	xorg-3_src_configure
}
