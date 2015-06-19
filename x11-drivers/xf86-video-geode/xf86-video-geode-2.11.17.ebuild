# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-geode/xf86-video-geode-2.11.17.ebuild,v 1.1 2015/05/24 02:58:31 mattst88 Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="AMD Geode GX2 and LX video driver"

KEYWORDS="x86"
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
