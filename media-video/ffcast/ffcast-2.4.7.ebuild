# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Run command on rectangular screen regions, e.g. screenshot, screencast"
HOMEPAGE="https://github.com/lolilolicon/FFcast"
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
		media-gfx/imagemagick
		>=app-shells/bash-4.3"
DEPEND=""

S="${WORKDIR}/FFcast-${PV}"

src_prepare() {
	rmdir src/xrectsel
	eautoreconf
}
