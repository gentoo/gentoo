# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A UNIX Shell with a simplified Scheme syntax"
HOMEPAGE="http://slon.ttk.ru/esh/"
SRC_URI="http://slon.ttk.ru/esh/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND=">=sys-libs/readline-4.1:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# For some reason, this tarball has binary files in it for x86.
	# Make clean so we can rebuild for our arch and optimization.
	emake clean

	sed -i \
		-e 's|-g ||' \
		-e 's|-DMEM_DEBUG ||' \
		-e 's|^CFLAGS|&+|g' \
		-e 's|$(CC) |&$(CFLAGS) $(CPPFLAGS) $(INC) $(LDFLAGS) $(LIB) $(LIBS)|g' \
		-e 's:-ltermcap::' \
		-e "s:/usr/include/readline:${ESYSROOT}/usr/include/readline:" \
		-e "s:LIB=-readline:$($(tc-getPKG_CONFIG) --libs readline):" \
		Makefile || die
}

src_compile() {
	use debug && append-flags -DMEM_DEBUG

	append-cppflags "$($(tc-getPKG_CONFIG) --cflags readline)"

	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} \$(INC)" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin esh
	doinfo doc/esh.info
	dodoc CHANGELOG CREDITS GC_README HEADER READLINE-HACKS TODO

	docinto html
	dodoc doc/*.html

	docinto examples
	dodoc examples/*
}
