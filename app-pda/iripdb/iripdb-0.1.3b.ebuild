# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/iripdb/iripdb-0.1.3b.ebuild,v 1.7 2014/08/10 18:19:12 slyfox Exp $

inherit eutils toolchain-funcs

MY_P=${P/iripdb/iRipDB}
S=${WORKDIR}/${PN}

DESCRIPTION="iRipDB allows generating the DB files necessary for the iRiver iHP-1xx series of MP3/Ogg HD Players"
HOMEPAGE="http://www.fataltourist.com/iripdb/"
SRC_URI="http://www.fataltourist.com/iripdb/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

RDEPEND="media-libs/taglib
	sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_compile() {
	echo "$(tc-getCXX) ${CXXFLAGS} -c -o main.o main.cpp"
	$(tc-getCXX) ${CXXFLAGS} -c -o main.o -I/usr/include/taglib main.cpp
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o iripdb main.o -lz -lm -ltag -lstdc++"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o iripdb main.o -lz -lm -ltag -lstdc++
}

src_install() {
	dobin iripdb || die
	dodoc AUTHORS README doc/iRivDB_structure || die
}
