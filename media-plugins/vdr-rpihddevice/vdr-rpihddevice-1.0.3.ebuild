# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="2045" #every bump, new version

DESCRIPTION="VDR Plugin: Output Device for Raspberry Pi"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-rpihddevice"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="~arm"
SLOT="0"
LICENSE="GPL-2"

DEPEND="media-libs/raspberrypi-userland
		media-video/vdr
		virtual/ffmpeg"

src_prepare()
{
	sed -i "${S}"/Makefile -e '/LDFLAGS.*VCLIBDIR/s/$/ -Wl,--no-as-needed/' || die "sed failed"
	vdr-plugin-2_src_prepare
}
