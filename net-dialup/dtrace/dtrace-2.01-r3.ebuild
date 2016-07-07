# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="DTRACE traces ISDN messages with AVM ISDN-controllers"
HOMEPAGE="ftp://ftp.avm.de/develper/d3trace/"
SRC_URI="ftp://ftp.avm.de/develper/d3trace/linux/dtrace.static -> ${P}.static
	ftp://ftp.avm.de/develper/d3trace/linux/readme.txt -> ${P}-readme.txt"

LICENSE="AVM-dtrace"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror bindist"

RDEPEND="net-dialup/capi4k-utils"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${P}.static "${DISTDIR}"/${P}-readme.txt . || die
}

src_prepare() {
	default
	edos2unix ${P}-readme.txt
}

src_install() {
	exeinto /opt/bin
	newexe ${P}.static dtrace-avm
	newdoc ${P}-readme.txt README
}
