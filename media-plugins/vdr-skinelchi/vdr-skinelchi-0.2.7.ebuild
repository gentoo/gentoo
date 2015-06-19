# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-skinelchi/vdr-skinelchi-0.2.7.ebuild,v 1.3 2015/02/20 13:43:23 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

MY_P=${P/_pre/pre}

DESCRIPTION="VDR Skin Plugin: skinelchi"
HOMEPAGE="http://firefly.vdr-developer.org/skinelchi"
SRC_URI="http://firefly.vdr-developer.org/skinelchi/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE="imagemagick"

DEPEND=">=media-video/vdr-1.6
		imagemagick? ( media-gfx/imagemagick )"

RDEPEND="x11-themes/vdr-channel-logos"

S=${WORKDIR}/${MY_P#vdr-}

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.1.1_pre2-r1.sh"

src_prepare() {
	vdr-plugin-2_src_prepare

	if ! use imagemagick; then
		einfo "Disabling imagemagick-support."
		sed -i "${S}"/Makefile \
			-e '/^[[:space:]]*SKINELCHI_HAVE_IMAGEMAGICK = 1/s/^/#/'
	fi

	sed -i "${S}"/DisplayChannel.c \
		-e "s:/hqlogos::" \
		-e "s:/logos::"
}
