# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A tapedrive tool for speeding up reading from and writing to tape"
HOMEPAGE="http://www.microwerks.net/~hugo/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc sparc x86"

src_prepare() {
	eapply "${FILESDIR}"/${PV}-deb-gentoo.patch
	sed -i -e 's/$(CFLAGS)/\0 $(LDFLAGS)/' Makefile || die
	emake clean
	default
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
