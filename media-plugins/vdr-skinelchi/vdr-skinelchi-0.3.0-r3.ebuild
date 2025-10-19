# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic vdr-plugin-2

DESCRIPTION="VDR Skin Plugin: skinelchi"
HOMEPAGE="http://firefly.vdr-developer.org/skinelchi/"
SRC_URI="http://firefly.vdr-developer.org/skinelchi/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="~media-video/vdr-2.2.0"
RDEPEND="${DEPEND}"

src_prepare() {
	if has_version ">=media-video/vdr-2.4"; then
		einfo "\nvdr-skinelchi is designed for media-video/vdr-2.2.x"
		einfo "\nuse media-plugins/vdr-skinelchihd instead\n"
		die "plugin too old for >=media-video/vdr-2.4"
	fi

	vdr-plugin-2_src_prepare

	#bug #599148
	append-cxxflags -std=gnu++11

	# disable imagemagick support, broken ...
	sed -i "${S}"/Makefile -e \
		"s:SKINELCHI_HAVE_IMAGEMAGICK = 1:SKINELCHI_HAVE_IMAGEMAGICK = 0:" || die

	sed -i "${S}"/DisplayChannel.c \
		-e "s:/hqlogos::" \
		-e "s:/logos::" || die

	# wrong sed in vdr-plugin-2.eclass?
	sed -e "s:INCLUDES += -I\$(VDRINCDIR):INCLUDES += -I\$(VDRINCDIR)/include:" \
		-i Makefile || die

	# gcc-6 warnings
	sed -e "s:auto_ptr:unique_ptr:" -i services/epgsearch_services.h || die

	# wrt bug 703994
	eapply "${FILESDIR}/${P}_min_max_from_stl.patch"
}
