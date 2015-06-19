# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unmakeself/unmakeself-1.0.ebuild,v 1.5 2008/07/24 15:57:45 armin76 Exp $

inherit toolchain-funcs

DESCRIPTION="extracting Makeself archives without having to run the self-extracting shell script"
HOMEPAGE="http://www.freshports.org/archivers/unmakeself"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${P}.tar.bz2"
#http://cvsup.pt.freebsd.org/cgi-bin/cvsweb/cvsweb.cgi/~checkout~/root/ports/ports/archivers/unmakeself/files/unmakeself.c

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/bzip2
	sys-libs/zlib
	app-arch/libarchive"
RDEPEND="${DEPEND}"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} unmakeself.c -larchive -lbz2 -lz  -o unmakeself
}

src_install() {
	dobin unmakeself
}
