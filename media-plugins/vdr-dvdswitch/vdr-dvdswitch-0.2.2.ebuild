# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

VERSION="1323" # every bump, new version

DESCRIPTION="VDR Plugin: to play dvds and dvd file structures"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-dvdswitch"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-2"
RDEPEND="media-plugins/vdr-dvd"

DEFAULT_IMAGE_DIR="/var/vdr/video/dvd-images"

VDR_CONFD_FILE="${FILESDIR}/0.1.3/confd-r2"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -e "s:/video/dvd:${DEFAULT_IMAGE_DIR}:" -i setup.c
}
