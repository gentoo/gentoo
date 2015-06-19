# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-channelblocker/vdr-channelblocker-0.0.6.ebuild,v 1.4 2014/05/30 12:29:46 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin to manage channel list for channelblocker"
HOMEPAGE="http://www.zulu-entertainment.de/download.php?group=Plugins"
SRC_URI="http://www.zulu-entertainment.de/files/vdr-channelblocker/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2"
RDEPEND="${DEPEND}"
