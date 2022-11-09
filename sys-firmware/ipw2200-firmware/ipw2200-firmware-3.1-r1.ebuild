# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/firmware/fw}

DESCRIPTION="Firmware for the Intel PRO/Wireless 2200BG/2915ABG miniPCI and 2225BG PCI"
HOMEPAGE="http://ipw2200.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="ipw2200-fw"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong x86"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /lib/firmware
	doins ipw2200-{bss,ibss,sniffer}.fw
}
