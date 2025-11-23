# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Record screencasts using ffmpeg"
HOMEPAGE="https://github.com/ropery/ffcast"
SRC_URI="https://github.com/ropery/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FFcast-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-apps/xdpyinfo
		x11-apps/xprop
		x11-apps/xwininfo
		x11-apps/xrectsel
		media-video/ffmpeg
		>=app-shells/bash-4.3"

src_prepare() {
	rmdir src/xrectsel
	eapply_user
	eautoreconf
}
