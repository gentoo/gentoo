# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

MY_P="${P/iripdb/iRipDB}"

DESCRIPTION="Allows generating the DB files necessary for the iRiver iHP-1xx"
HOMEPAGE="http://www.fataltourist.com/iripdb/"
SRC_URI="http://www.fataltourist.com/iripdb/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	media-libs/taglib
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S="${WORKDIR}/${PN}"

src_compile() {
	echo "$(tc-getCXX) ${CXXFLAGS} -c -o main.o main.cpp"
	$(tc-getCXX) ${CXXFLAGS} -c -o main.o -I/usr/include/taglib main.cpp || die
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o iripdb main.o -lz -lm -ltag -lstdc++"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o iripdb main.o -lz -lm -ltag -lstdc++ || die
}

src_install() {
	dobin iripdb
	dodoc AUTHORS README doc/iRivDB_structure
}
