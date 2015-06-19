# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-launcher/vdr-launcher-0.0.4.ebuild,v 1.4 2014/02/23 20:11:03 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: launch other plugins - even when their menu-entry is hidden"
HOMEPAGE="http://people.freenet.de/cwieninger/html/vdr-launcher.html"
SRC_URI="http://winni.vdr-developer.org/launcher/downloads/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.7"
RDEPEND="${DEPEND}"
