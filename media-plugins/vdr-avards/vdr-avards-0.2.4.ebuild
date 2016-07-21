# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin:  Automatic Video Aspect Ratio Detection and Signaling"
HOMEPAGE="http://firefly.vdr-developer.org/avards/"
SRC_URI="http://firefly.vdr-developer.org/avards/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "s:i18n.c:i18n.h:g" Makefile

	if ! has_version ">=media-video/vdr-1.7.13"; then
		sed -i "s:-include \$(VDRDIR)/Make.global:#-include \$(VDRDIR)/Make.global:" Makefile
	fi

	# fix deprecated i18n handling >=vdr-1.7.27
	sed -i "s:i18n.o::" Makefile || die "sed makefile faild"
	sed -i "s:extern://extern:" i18n.h || die "sed i18n.h failed"
}
