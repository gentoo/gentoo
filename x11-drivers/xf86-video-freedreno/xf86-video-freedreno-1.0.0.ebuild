# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-freedreno/xf86-video-freedreno-1.0.0.ebuild,v 1.2 2014/06/08 09:16:30 ago Exp $

EAPI=5

XORG_DRI=always
inherit xorg-2

DESCRIPTION="Driver for Adreno mobile GPUs"
KEYWORDS="arm"
IUSE=""

RDEPEND="x11-libs/libdrm[video_cards_freedreno]"
DEPEND="${RDEPEND}"

src_prepare() {
	# Gentoo installs drm_mode.h to /usr/include/libdrm/
	sed -i 's:drm/drm_mode.h:libdrm/drm_mode.h:' src/drmmode_display.c || die
	xorg-2_src_prepare
}
