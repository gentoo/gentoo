# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}v3-${PV}

DESCRIPTION="Commandline program to transcode shoutcast/icecast streams to different bitrates"
HOMEPAGE="http://www.oddsock.org/tools/streamTranscoderV3"
SRC_URI="http://www.oddsock.org/tools/streamTranscoderV3/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=media-libs/libogg-1.1
	>=media-libs/libvorbis-1.0.1-r2
	>=media-sound/lame-3.96
	>=media-libs/libmad-0.15.1b
	>=net-misc/curl-7.11.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}
