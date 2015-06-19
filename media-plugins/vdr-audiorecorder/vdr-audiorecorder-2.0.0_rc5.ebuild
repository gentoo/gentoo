# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-audiorecorder/vdr-audiorecorder-2.0.0_rc5.ebuild,v 1.1 2014/11/05 14:44:38 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

VERSION="1818" # every bump, new version

DESCRIPTION="VDR plugin: automatically record radio-channels and split it into tracks according to RadioText-Info"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-audiorecorder/"
SRC_URI="mirror://vdr-developerorg/${VERSION}/vdr-plugin-audiorecorder-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/vdr-plugin-audiorecorder-${PV}"

DEPEND=">=media-video/vdr-2
		media-libs/taglib
		virtual/ffmpeg[encode,mp3]
		>=dev-libs/tinyxml-2.6.1[stl]"
RDEPEND="${DEPEND}"

src_install() {
	vdr-plugin-2_src_install

	keepdir /var/vdr/audiorecorder
	chown -R vdr:vdr "${D}"/var/vdr

	insinto /etc/vdr/plugins/audiorecorder
	doins "${S}"/contrib/audiorecorder.conf
}
