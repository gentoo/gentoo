# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/firmware/fw}

DESCRIPTION="Firmware for the Intel PRO/Wireless 2100 3B miniPCI adapter"
HOMEPAGE="http://ipw2100.sourceforge.net/"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="ipw2100-fw"
SLOT="${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~loong x86"

S=${WORKDIR}

src_install() {
	insinto /lib/firmware
	doins ipw2100-${PV}{,-i,-p}.fw
}
