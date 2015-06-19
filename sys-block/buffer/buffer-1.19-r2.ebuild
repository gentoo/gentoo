# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/buffer/buffer-1.19-r2.ebuild,v 1.6 2011/11/27 06:44:26 radhermit Exp $

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="a tapedrive tool for speeding up reading from and writing to tape"
HOMEPAGE="http://www.microwerks.net/~hugo/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc sparc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-deb-gentoo.patch
	sed -i -e 's/$(CFLAGS)/\0 $(LDFLAGS)/' Makefile || die
	emake clean
}

src_compile() {
	append-lfs-flags
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin buffer
	dodoc README
	newman buffer.man buffer.1
}
