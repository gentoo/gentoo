# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Record screencasts using ffmpeg"
HOMEPAGE="https://github.com/lolilolicon/ffcast"
SRC_URI="https://github.com/lolilolicon/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-apps/xdpyinfo
		x11-apps/xprop
		x11-apps/xwininfo
		x11-apps/xrectsel
		media-video/ffmpeg
		>=app-shells/bash-4.3"
DEPEND=""

S="${WORKDIR}/FFcast-${PV}"

src_prepare() {
	rmdir src/xrectsel
	eautoreconf
}
