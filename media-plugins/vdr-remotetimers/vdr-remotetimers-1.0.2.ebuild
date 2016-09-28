# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: edit timers on remote vdr instances"
HOMEPAGE="http://vdr.schmirler.de/"
SRC_URI="http://vdr.schmirler.de/${PN#vdr-}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
RDEPEND="${DEPEND}"
