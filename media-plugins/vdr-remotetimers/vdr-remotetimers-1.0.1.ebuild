# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-remotetimers/vdr-remotetimers-1.0.1.ebuild,v 1.3 2014/12/27 00:34:41 patrick Exp $

EAPI="5"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: edit timers on remote vdr instances"
HOMEPAGE="http://vdr.schmirler.de/"
SRC_URI="http://vdr.schmirler.de/${PN#vdr-}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_vdr-2.1.2.diff" )
