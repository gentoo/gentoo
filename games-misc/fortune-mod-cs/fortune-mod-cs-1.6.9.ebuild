# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Database of the Czech and Slovak cookies for the fortune(6) program"
HOMEPAGE="http://ftp.fi.muni.cz/pub/linux/people/zdenek_pytela/"
SRC_URI="http://ftp.fi.muni.cz/pub/linux/people/zdenek_pytela/${P/-mod/}.tar.bz2"
S="${WORKDIR}"/${P/-mod/}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="unicode"

RDEPEND="games-misc/fortune-mod"
DEPEND="${RDEPEND}"
BDEPEND="unicode? ( virtual/libiconv )"

src_prepare() {
	default

	rm -f LICENSE install.sh fortune-cs.* *xpm || die
}

src_compile() {
	local f
	for f in [[:lower:]]* ; do
		if use unicode ; then
			iconv -f iso-8859-2 -t utf8 ${f} > ${f}.utf8 || die
			mv ${f}.utf8 ${f} || die
		fi
		strfile -s ${f} || die "strfile ${f} failed"
	done
}

src_install() {
	insinto /usr/share/fortune/cs
	doins [[:lower:]]*
	dodoc [[:upper:]]*
}
