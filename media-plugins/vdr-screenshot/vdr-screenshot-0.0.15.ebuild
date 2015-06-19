# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-screenshot/vdr-screenshot-0.0.15.ebuild,v 1.2 2014/01/02 13:22:14 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: takes screenshots of the current video or tv screen by one keypress on your remote"
HOMEPAGE="http://www.joachim-wilke.de/?alias=vdr-screenshot"
SRC_URI="http://www.joachim-wilke.de/downloads/${PN}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0"
RDEPEND="${DEPEND}"
