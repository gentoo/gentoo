# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Microsoft's NTLM authentication (libntlm) library"
HOMEPAGE="http://www.nongnu.org/libntlm/"
SRC_URI="http://www.nongnu.org/${PN}/releases/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~amd64-linux"
IUSE=""

src_configure() {
	econf --disable-valgrind-tests
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}
