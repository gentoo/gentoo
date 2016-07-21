# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs eutils

DESCRIPTION="Hassle-free Usenet news system for small sites"
SRC_URI="http://infa.abo.fi/~patrik/sn/files/${P}.tar.bz2"
HOMEPAGE="http://infa.abo.fi/~patrik/sn/"

KEYWORDS="~amd64 x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qa.patch
	epatch "${FILESDIR}"/${P}-parallel-make.patch

	sed -i -e 's/-g -Wall -pedantic -O/-Wall -pedantic/' Makefile || die
}

src_compile() {
	emake cc-flags
	echo ${CFLAGS} >>cc-flags

	emake CC="$(tc-getCC)" LD="$(tc-getCC) ${LDFLAGS}" \
		SNROOT=/var/spool/news \
		BINDIR=/usr/sbin \
		MANDIR=/usr/share/man
}

src_install() {
	dodir /var/spool/news /usr/sbin /usr/share/man/man8
	mknod -m 600 "${D}"/var/spool/news/.fifo p
	emake install \
		SNROOT="${D}"/var/spool/news \
		BINDIR="${D}"/usr/sbin \
		MANDIR="${D}"/usr/share/man
	dodoc CHANGES FAQ INSTALL* INTERNALS README* THANKS TODO
	fowners news:news /var/spool/news{,/.fifo}
}
