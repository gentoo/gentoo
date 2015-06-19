# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/projectm-jack/projectm-jack-2.1.0.ebuild,v 1.5 2014/08/10 21:10:15 slyfox Exp $

EAPI=5

inherit cmake-utils

MY_P=${PN/m-jack/M}-complete-${PV}-Source

DESCRIPTION="A Qt based GUI for projectM that visualizes your JACK output"
HOMEPAGE="http://projectm.sourceforge.net"
SRC_URI="mirror://sourceforge/projectm/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	media-sound/jack-audio-connection-kit
	>=media-libs/libprojectm-qt-2.1.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}/src/${PN/m/M}"
