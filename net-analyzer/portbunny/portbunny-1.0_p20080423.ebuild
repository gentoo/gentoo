# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils linux-mod

MY_PV_SNAP=${PV##*_p}
if [[ ${MY_PV_SNAP} != ${PV} ]]; then
	MY_PV=${MY_PV_SNAP:6:2}${MY_PV_SNAP:4:2}${MY_PV_SNAP:2:2}
	MY_P=PortBunny${MY_PV}
	S="${WORKDIR}"/${MY_P}-dev
else
	MY_P=PortBunny-${PV}
	S="${WORKDIR}"/${MY_P}
fi

MODULE_NAMES="portbunny(kernel:)"
BUILD_TARGETS="all"

DESCRIPTION="A kernel based highspeed TCP SYN port scanner"
HOMEPAGE="http://recurity-labs.com/portbunny/"
SRC_URI="http://recurity-labs.com/portbunny/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/python"

src_install() {
	insinto /usr/share/portbunny
	doins UI/share/portbunny/*
	dosed "s:^\(ETC_SERVICES\)[[:space:]]\+=.*:\1 = '/usr/share/portbunny/services':g" \
		/usr/share/portbunny/PBunnyServices.py
	dobin UI/bin/portbunny.py
	dosym portbunny.py /usr/bin/portbunny
	dosed "s:^\(PBUNNY_SHARE\)[[:space:]]\+=.*:\1 = '/usr/share/portbunny/':g" \
		/usr/bin/portbunny.py
	dosed "s:^\(PBUNNY_SHARE2\)[[:space:]]\+=.*:\1 = '/usr/share/portbunny/':g" \
		/usr/bin/portbunny.py

	linux-mod_src_install
}

pkg_postinst() {
	einfo
	einfo "See http://recurity-labs.com/portbunny/README.pdf"
	einfo
	ewarn
	ewarn "WARNING"
	ewarn "WARNING: this software may HARM the stability of your system!"
	ewarn "WARNING: do NOT use this on production machines!"
	ewarn "WARNING"
	ewarn
	ebeep 10
}
