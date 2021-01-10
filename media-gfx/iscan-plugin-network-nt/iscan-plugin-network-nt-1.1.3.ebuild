# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info rpm

DESCRIPTION="Network scanning plugin for EPSON scanners (nonfree)"

HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
# This is distributed as part of the "bundle driver"; since we already have the
# opensource part separately we just install the nonfree part here.

ISCAN_VERSION="3.62.0"

SRC_URI="https://download2.ebz.epson.net/imagescanv3/centos/latest1/rpm/x64/imagescan-bundle-centos-8-${ISCAN_VERSION}.x64.rpm.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-gfx/iscan"
RESTRICT="bindist mirror strip"
# https://bugs.gentoo.org/364129#c15
CONFIG_CHECK="~SYN_COOKIES"
S=${WORKDIR}

QA_PREBUILT="/usr/libexec/utsushi/networkscan"

src_unpack() {
	default
	rpm_unpack ./imagescan-bundle-centos-8-${ISCAN_VERSION}.x64.rpm/plugins/imagescan-plugin-networkscan-${PV}-1epson4centos8.x86_64.rpm
}

src_install() {
	exeinto /usr/libexec/utsushi
	doexe usr/libexec/utsushi/networkscan

	gunzip usr/share/doc/imagescan-plugin-networkscan/*.gz
	dodoc usr/share/doc/imagescan-plugin-networkscan/*
}
