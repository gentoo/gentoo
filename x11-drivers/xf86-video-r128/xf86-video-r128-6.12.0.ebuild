# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI=dri

inherit flag-o-matic xorg-3

DESCRIPTION="ATI Rage128 video driver"

KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.2"
DEPEND="${RDEPEND}"

src_configure() {
	# always use C11 semantics
	append-cflags -std=gnu11

	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable dri)
	)
	xorg-3_src_configure
}
