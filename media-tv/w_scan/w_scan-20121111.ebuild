# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Scan for DVB-C/DVB-T/DVB-S channels without prior knowledge of frequencies and modulations"
HOMEPAGE="http://wirbel.htpc-forum.de/w_scan/index2.html"
SRC_URI="http://wirbel.htpc-forum.de/w_scan/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND=">=virtual/linuxtv-dvb-headers-5.3"
RDEPEND=""

src_prepare() {
	# support dvb api 5.8
	if has_version ">=virtual/linuxtv-dvb-headers-5.8"; then
		sed -e "s:DTV_DVBT2_PLP_ID:DTV_STREAM_ID:" -i scan.c
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog README

	if use doc; then
		dodoc doc/README.file_formats doc/README_VLC_DVB
	fi

	if use examples; then
		docinto examples
		dodoc doc/rotor.conf
	fi
}
