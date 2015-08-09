# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="ReplayGain for WAVE audio files"
HOMEPAGE="http://www.rarewares.org/files/others/"
SRC_URI="http://www.rarewares.org/files/others/${P}srcs.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P/wavegain/WaveGain}

src_compile(){
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} *.c -o ${PN} \
		-DHAVE_CONFIG_H -lm || die "build failed"
}

src_install(){
	dobin ${PN}
}
