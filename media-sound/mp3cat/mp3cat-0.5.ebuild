# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Reads and writes MP3 files"
HOMEPAGE="https://tomclegg.ca/mp3cat"
SRC_URI="https://github.com/tomclegg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	default
	sed -i -e 's:cc -o:${CC} ${CFLAGS} ${LDFLAGS} -o:' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf
}
