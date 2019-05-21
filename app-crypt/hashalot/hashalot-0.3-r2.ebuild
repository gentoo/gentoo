# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Reads a passphrase and prints a hash"
HOMEPAGE="http://www.paranoiacs.org/~sluskyb/"
SRC_URI="http://www.paranoiacs.org/~sluskyb/hacks/hashalot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""

src_test() {
	make check-TESTS || die
}

src_install() {
	make DESTDIR="${D}" install || die "install error"
	dodoc ChangeLog NEWS README
}
