# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Database of the Czech and Slovak cookies for the fortune(6) program"
HOMEPAGE="http://ftp.fi.muni.cz/pub/linux/people/zdenek_pytela/"
SRC_URI="http://ftp.fi.muni.cz/pub/linux/people/zdenek_pytela/${P/-mod/}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="unicode"

RDEPEND="games-misc/fortune-mod"
DEPEND="${RDEPEND}
	unicode? ( virtual/libiconv )"

S=${WORKDIR}/${P/-mod/}

src_prepare() {
	rm -f LICENSE install.sh fortune-cs.* *xpm
}

src_compile() {
	local f
	for f in [[:lower:]]* ; do
		if use unicode ; then
			iconv --from-code iso-8859-2 --to-code utf8 -o${f}.utf8 ${f}
			mv ${f}.utf8 ${f}
		fi
		strfile -s ${f} || die "strfile ${f} failed"
	done
}

src_install() {
	insinto /usr/share/fortune/cs
	doins [[:lower:]]*
	dodoc [[:upper:]]*
}
