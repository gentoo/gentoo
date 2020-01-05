# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Skin Plugin: skinelchi"
HOMEPAGE="http://firefly.vdr-developer.org/skinelchi"
SRC_URI="http://firefly.vdr-developer.org/skinelchi/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"

src_prepare() {
	vdr-plugin-2_src_prepare

	#bug #599148
	append-cxxflags -std=gnu++11

	# disable imagemagick support, broken ...
	sed -i "${S}"/Makefile -e \
		"s:SKINELCHI_HAVE_IMAGEMAGICK = 1:SKINELCHI_HAVE_IMAGEMAGICK = 0:"

	sed -i "${S}"/DisplayChannel.c \
		-e "s:/hqlogos::" \
		-e "s:/logos::"

	# wrong sed in vdr-plugin-2.eclass?
	sed -e "s:INCLUDES += -I\$(VDRINCDIR):INCLUDES += -I\$(VDRINCDIR)/include:" \
		-i Makefile

	# gcc-6 warnings
	sed -e "s:auto_ptr:unique_ptr:" -i services/epgsearch_services.h

	# wrt bug 703994
	eapply "${FILESDIR}/${P}_min_max_from_stl.patch"
}
