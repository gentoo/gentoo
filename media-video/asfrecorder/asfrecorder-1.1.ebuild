# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

MY_PN="${PN/asfr/ASFR}"
DESCRIPTION="ASFRecorder - Download Windows Media Streaming files"
HOMEPAGE="https://sourceforge.net/projects/asfrecorder/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_compile() {
	# There is a Makefile, but it only works for Cygwin, so we
	# only compile this single program.
	cd "${S}"/source
	$(tc-getCC) -o asfrecorder ${CFLAGS} ${LDFLAGS} asfrecorder.c || die "Build failed"
}

src_install () {
	# Again, no makefiles, so just take what we want.
	dobin source/asfrecorder
	dodoc README.TXT
}
