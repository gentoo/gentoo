# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="mp3cat reads and writes MP3 files"
HOMEPAGE="http://tomclegg.net/mp3cat"
SRC_URI="http://tomclegg.net/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	sed -i -e 's:cc -o:${CC} ${CFLAGS} ${LDFLAGS} -o:' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf
}
