# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-powermate/vdr-powermate-0.0.5.ebuild,v 1.4 2015/02/20 13:36:44 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR PLUGIN: support the Powermate device"
HOMEPAGE="http://home.arcor.de/andreas.regel/vdr_plugins.htm"
SRC_URI="http://home.arcor.de/andreas.regel/files/powermate/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-video/vdr-1.5.8"
DEPEND="${RDEPEND}"
