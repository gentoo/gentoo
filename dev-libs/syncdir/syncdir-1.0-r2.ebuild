# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Provides an alternate implementation for open, link, rename, and unlink"
HOMEPAGE="https://untroubled.org/syncdir"
SRC_URI="https://untroubled.org/syncdir/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE="static-libs"

src_prepare() {
	default
	if ! use static-libs; then
		sed -i Makefile \
			-e '/^all:/s|libsyncdir.a||' \
			-e '/install -m 644 libsyncdir.a/d' \
			|| die "sed Makefile"
	fi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		libsyncdir.so \
		$(use static-libs && echo libsyncdir.a)
}

src_install() {
	dodir /usr/$(get_libdir)
	emake libdir="${D}/usr/$(get_libdir)" install
	dodoc testsync.c
}
