# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils unpacker

DESCRIPTION="design and build bridges and then stress test them with trains"
HOMEPAGE="http://www.chroniclogic.com/pontifex2.htm"
SRC_URI="ftp://ggdev-1.homelan.com/bcs/bcsdemo_v${PV/./_}.sh.bin
	http://www.highprogrammer.com/alan/pfx2/openal-alan-hack-0.0.1.tar.gz"

LICENSE="BCS"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-)]
	sys-libs/glibc
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

S=${WORKDIR}

dir=/opt/${PN}
Ddir=${D}/${dir}
QA_PREBUILT="${dir:1}/*"

src_unpack() {
	unpack_makeself bcsdemo_v${PV/./_}.sh.bin
	unpack openal-alan-hack-0.0.1.tar.gz
}

src_install() {
	dodir "${dir}"

	tar -zxf bcsdemo.tar.gz -C "${Ddir}" || die
	rm -f "${Ddir}"/bcs-linux-openal-fixer.sh || die

	exeinto "${dir}"
#	doexe bin/Linux/x86/rungame.sh
#	exeinto ${dir}/lib
	mv "${Ddir}"/bcs "${Ddir}"/bcs-bin
	newexe libopenal.so.0.0.6 libopenal.so.0
	echo '#!/bin/bash' >> "${Ddir}"/bcs
	echo 'LD_PRELOAD="./libopenal.so.0" ./bcs-bin' >> "${Ddir}"/bcs
	fperms 755 "${dir}"/bcs
	make_wrapper bcs-demo ./bcs "${dir}" "${dir}"

	insinto "${dir}"
	doins *.cfg
	dodoc readme*
}
