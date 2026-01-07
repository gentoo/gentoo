# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic xorg-3

DESCRIPTION="ATI Rage128 video driver"

KEYWORDS="~alpha amd64 ~loong ppc ppc64 ~sparc x86"

src_configure() {
	# always use C11 semantics
	append-cflags -std=gnu11

	local XORG_CONFIGURE_OPTIONS=(
		--disable-dri
	)
	xorg-3_src_configure
}
