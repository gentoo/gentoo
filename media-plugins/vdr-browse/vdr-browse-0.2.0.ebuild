# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-browse/vdr-browse-0.2.0.ebuild,v 1.3 2012/06/30 18:23:55 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: browse now/next epg info while keep watching the current channel"
HOMEPAGE="http://www.fepg.org/"
SRC_URI="http://www.fepg.org/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.36"
RDEPEND="${DEPEND}"
