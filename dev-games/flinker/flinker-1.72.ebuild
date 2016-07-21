# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="GBA cart writing utility by Jeff Frohwein"
HOMEPAGE="http://www.devrs.com/gba/software.php#misc"
SRC_URI="http://www.devrs.com/gba/files/flgba.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	sed -i \
		-e '/unistd/s:^//::' \
		-e 's:asm/io.h:sys/io.h:' \
		fl.c || die
	echo >> fl.c
	echo >> cartlib.c
}
src_compile() {
	$(tc-getCC) ${LDFLAGS} -o FLinker ${CFLAGS} fl.c || die
}

src_install() {
	dobin FLinker
	dodoc readme
}
