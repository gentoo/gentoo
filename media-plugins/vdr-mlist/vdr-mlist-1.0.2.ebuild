# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-mlist/vdr-mlist-1.0.2.ebuild,v 1.2 2014/01/02 16:58:19 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Show a history of the last OSD message"
HOMEPAGE="http://www.joachim-wilke.de/?alias=vdr-mlist"
SRC_URI="http://joachim-wilke.de/vdr-mlist/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0"
RDEPEND="${DEPEND}"
