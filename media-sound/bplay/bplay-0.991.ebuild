# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="No-frills command-line buffered player and recorder"
HOMEPAGE="http://www.amberdata.demon.co.uk/bplay/"
SRC_URI="http://www.amberdata.demon.co.uk/bplay/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc sparc x86"

src_compile() {
	emake \
		LDFLAGS="${LDFLAGS}" \
		CFLAGS="${CFLAGS} -DUSEBUFFLOCK" \
		CC="$(tc-getCC)" bplay
}

src_install () {
	newbin bplay bplay-bin
	dosym bplay-bin /usr/bin/brec
	doman brec.1
	newman bplay.1 bplay-bin.1
	einstalldocs
}
