# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

MY_P="${PN/util/}-${PV}"
DESCRIPTION="Command line program ('aes') to encrypt and decrypt data using the Rijndael algorithm"
HOMEPAGE="http://my.cubic.ch/users/timtas/aes/"
SRC_URI="http://my.cubic.ch/users/timtas/aes/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ~ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "/^CFLAGS/s:-g -Wall:${CFLAGS}:" Makefile.linux > Makefile \
		|| die "Sed failed"
	sed -i -e "/^LDFLAGS/s:-g:${LDFLAGS}:" Makefile || die "Sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin aes || die
	dodoc CHANGES INSTALL README TODO || die
}
