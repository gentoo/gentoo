# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: use various devices for controlling vdr (keyboards, lirc...)"
HOMEPAGE="http://www.escape-edv.de/endriss/vdr/"
SRC_URI="https://github.com/typingArtist/vdr-plugin-remote/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-remote-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

DEPEND="
	>=media-video/vdr-2.6
"
RDEPEND="
	${DEPEND}
	systemd? ( acct-user/vdr[remote,systemd] )
"
