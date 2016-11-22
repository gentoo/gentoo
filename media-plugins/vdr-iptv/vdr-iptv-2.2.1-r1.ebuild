# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Add a logical device capable of receiving IPTV"
HOMEPAGE="http://www.saunalahti.fi/~rahrenbe/vdr/iptv/"
SRC_URI="http://www.saunalahti.fi/~rahrenbe/vdr/iptv/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.1.6"
RDEPEND="${DEPEND}
		net-misc/curl"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include sidscanner.c

	eapply "${FILESDIR}/${P}_c++11.patch"
}

#src_install() {
#	vdr-plugin-2_src_install

#	dobin iptv/image.sh
#	dobin iptv/iptvstream-notrap.sh
#	dobin iptv/linein.sh
#	dobin iptv/webcam.sh
#	dobin iptv/internetradio.sh
#	dobin iptv/iptvstream.sh
#	dobin iptv/vlc2iptv

#	insinto /usr/share/vdr/plugins/iptv
#	doins iptv/*
#}
