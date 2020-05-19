# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info rpm

DESCRIPTION="Network scanning plugin for EPSON scanners (nonfree)"

HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
# This is distributed as part of the "bundle driver"; since we already have the
# opensource part separately we just install the nonfree part here.

ISCAN_VERSION="3.62.0"

SRC_URI="
	amd64?	( https://download2.ebz.epson.net/imagescanv3/fedora/latest2/rpm/x64/imagescan-bundle-fedora-30-${ISCAN_VERSION}.x64.rpm.tar.gz )
	x86?	( https://download2.ebz.epson.net/imagescanv3/fedora/latest2/rpm/x86/imagescan-bundle-fedora-30-${ISCAN_VERSION}.x86.rpm.tar.gz )"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-gfx/iscan"
RESTRICT="bindist mirror strip"
# https://bugs.gentoo.org/364129#c15
CONFIG_CHECK="~SYN_COOKIES"
S=${WORKDIR}

src_unpack() {
	default
	if use x86; then
		rpm_unpack ./imagescan-bundle-fedora-30-${ISCAN_VERSION}.x86.rpm/plugins/imagescan-plugin-networkscan-${PV}-1epson4fedora30.i686.rpm
	else
		rpm_unpack ./imagescan-bundle-fedora-30-${ISCAN_VERSION}.x64.rpm/plugins/imagescan-plugin-networkscan-${PV}-1epson4fedora30.x86_64.rpm
	fi
}

src_install() {
	exeinto /usr/libexec/utsushi
	doexe usr/libexec/utsushi/networkscan

	gunzip usr/share/doc/imagescan-plugin-networkscan/*.gz
	dodoc usr/share/doc/imagescan-plugin-networkscan/*
}
