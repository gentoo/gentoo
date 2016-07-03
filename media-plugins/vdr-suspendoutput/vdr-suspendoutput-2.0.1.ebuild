# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Show still image instead of live tv to safe cpu"
HOMEPAGE="http://phivdr.dyndns.org/vdr/vdr-suspendoutput/"
SRC_URI="http://phivdr.dyndns.org/vdr/vdr-suspendoutput/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	# compile fix, wrt bug 574162
	sed -e 246c"unsigned int TimeoutMs, bool runOnce)" \
		-e 254c"unsigned int TimeoutMs, bool runOnce)" \
		-i timer.h
}