# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vdr-plugin-2

MY_P=${P/_pre/pre}

DESCRIPTION="VDR Skin Plugin: skinelchi"
HOMEPAGE="http://firefly.vdr-developer.org/skinelchi"
SRC_URI="http://firefly.vdr-developer.org/skinelchi/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
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

	# wrong sed in vdr-plugin-2.eclass?
	sed -e "s:INCLUDES += -I\$(VDRINCDIR):INCLUDES += -I\$(VDRINCDIR)/include:" \
		-i Makefile

	# gcc-6 warnings
	sed -e "s:auto_ptr:unique_ptr:" -i services/epgsearch_services.h
}
