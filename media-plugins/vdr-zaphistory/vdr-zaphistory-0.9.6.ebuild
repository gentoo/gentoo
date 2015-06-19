# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-zaphistory/vdr-zaphistory-0.9.6.ebuild,v 1.2 2014/03/02 19:34:45 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

VERSION="1437" # every bump, new Version

DESCRIPTION="VDR Plugin: Shows the least recently used channels"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-zaphistory"
SRC_URI="mirror://vdr-developerorg/${VERSION}/zaphistory-${PV}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${P}-fix-crash-no-info.diff")
