# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Inter7 Email Processing and mht System library"
HOMEPAGE="http://www.inter7.com/eps"
SRC_URI="http://www.inter7.com/eps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${P}-static-libs.patch )

src_prepare() {
	sed -i -e 's:/usr:$(DESTDIR)$(prefix):g' \
		-e 's:\(DEFS.*\):\1 $(CFLAGS):' \
		-e 's:$(DEFS):$(DEFS) -fPIC:' \
		-e 's:-shared:-shared -Wl,-soname,libeps.so $(LDFLAGS):' \
		-e 's:cp -pf:cp -f:g' \
		Makefile || die
	default
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)"
}

src_install() {
	emake prefix=/usr DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" install
	dodoc ChangeLog TODO doc/*
}
