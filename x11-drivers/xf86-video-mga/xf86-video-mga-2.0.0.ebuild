# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI=dri
inherit xorg-3

DESCRIPTION="Matrox video driver"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable dri)
	)
	xorg-3_src_configure
}
