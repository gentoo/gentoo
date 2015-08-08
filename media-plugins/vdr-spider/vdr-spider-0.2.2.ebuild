# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Spider patience game"
HOMEPAGE="http://toms-cafe.de/vdr/spider/"
SRC_URI="http://toms-cafe.de/vdr/spider/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.47"

SPIDER_DATA_DIR="/usr/share/vdr/spider"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i spider.cpp -e 's:ConfigDirectory(Name()):"'${SPIDER_DATA_DIR}'":'
}

src_install() {
	vdr-plugin-2_src_install

	insinto "${SPIDER_DATA_DIR}"
	doins "${S}"/spider/*.xpm
}
