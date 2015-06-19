# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-zappilot/vdr-zappilot-0.0.5.ebuild,v 1.2 2014/01/02 12:38:25 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

VERSION="1318" # every bump new version

DESCRIPTION="VDR Plugin: browse fast the EPG information without being forced to switch to a channel"
HOMEPAGE="http://projects.vdr-developer.org/projects/show/plg-zappilot"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.7.34"
RDEPEND="${DEPEND}"
