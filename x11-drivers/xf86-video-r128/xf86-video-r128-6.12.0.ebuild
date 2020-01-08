# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_DRI=dri

inherit flag-o-matic xorg-2

DESCRIPTION="ATI Rage128 video driver"

KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.2"
DEPEND="${RDEPEND}"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable dri)
	)
}

src_configure() {
	# always use C11 semantics
	append-cflags -std=gnu11

	xorg-2_src_configure
}
