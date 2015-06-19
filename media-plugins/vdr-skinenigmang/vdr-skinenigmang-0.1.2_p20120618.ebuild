# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-skinenigmang/vdr-skinenigmang-0.1.2_p20120618.ebuild,v 1.2 2012/10/03 15:05:00 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

HG_REVISION="44e1d4ad341963d099ccc9bc4017ae4b563892d4"
HG_REVISION_DATE="20120618"

DESCRIPTION="VDR - Skin Plugin: enigma-ng"
HOMEPAGE="http://andreas.vdr-developer.org/enigmang/"
SRC_URI="http://vdr.websitec.de/download/vdr-skinenigmang/vdr-skinenigmang-0.1.2_p${HG_REVISION_DATE}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="imagemagick"

DEPEND=">=media-video/vdr-1.5.7"

RDEPEND="${DEPEND}
		x11-themes/skinenigmang-logos
		imagemagick? ( media-gfx/imagemagick[cxx] )"

S="${WORKDIR}/vdr-plugin-skinenigmang-${HG_REVISION}"

src_prepare() {
	vdr-plugin-2_src_prepare

	use imagemagick && sed -i "s:#HAVE_IMAGEMAGICK:HAVE_IMAGEMAGICK:" Makefile

	# TODO: implement a clean query / extra tool vdr-config
	sed -i -e '/^VDRLOCALE/d' Makefile

	if has_version ">=media-video/vdr-1.5.9"; then
		sed -i -e 's/.*$(VDRLOCALE).*/ifeq (1,1)/' Makefile
	fi

	sed -i -e "s:-I/usr/local/include/ImageMagick::" Makefile
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/themes
	doins "${S}"/themes/*
}
