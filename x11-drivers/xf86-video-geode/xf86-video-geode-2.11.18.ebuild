# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="AMD Geode GX2 and LX video driver"

KEYWORDS="~x86"
IUSE="ztv"

RDEPEND=""
DEPEND="${RDEPEND}
	ztv? (
		sys-kernel/linux-headers
	)"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ztv)
	)
	xorg-2_src_configure
}
