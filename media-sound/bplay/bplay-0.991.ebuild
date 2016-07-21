# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="No-frills command-line buffered player and recorder"
HOMEPAGE="http://www.amberdata.demon.co.uk/bplay/"
SRC_URI="http://www.amberdata.demon.co.uk/bplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc sparc x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" \
		CFLAGS="${CFLAGS} -DUSEBUFFLOCK" bplay || die "emake failed"
}

src_install () {
	newbin bplay bplay-bin || die "dobin failed"
	dosym bplay-bin /usr/bin/brec || die "dosym failed"
	doman brec.1
	newman bplay.1 bplay-bin.1
	dodoc README
}
