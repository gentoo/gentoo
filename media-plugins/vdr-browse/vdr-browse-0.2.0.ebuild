# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
