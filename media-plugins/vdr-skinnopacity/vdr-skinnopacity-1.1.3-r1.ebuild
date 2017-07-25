# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/vdr-}"
VERSION="1743"

inherit vdr-plugin-2

DESCRIPTION="VDR Skin Plugin: customizable native true color skin for the Video Disc Recorder"
HOMEPAGE="http://projects.vdr-developer.org/projects/skin-nopacity/"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/curl
	dev-libs/libxml2
	media-plugins/vdr-epgsearch
	|| (
		<media-gfx/imagemagick-7[jpeg,png,svg,tiff]
		media-gfx/graphicsmagick[imagemagick,jpeg,png,svg,tiff]
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version media-gfx/graphicsmagick; then
		sed -i -e 's:^IMAGELIB =.*:IMAGELIB = graphicsmagick:' Makefile || die
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	einfo "See http://projects.vdr-developer.org/projects/skin-nopacity/wiki"
	einfo "for more information about how to use channel logos"
}
