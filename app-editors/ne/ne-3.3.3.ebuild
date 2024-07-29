# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The nice editor, easy to use for the beginner and powerful for the wizard"
HOMEPAGE="https://ne.di.unimi.it/"
SRC_URI="https://ne.di.unimi.it/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="sys-libs/ncurses:="
RDEPEND="
	${DEPEND}
	dev-lang/perl
"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( doc/html/. )

src_prepare() {
	default

	sed -i \
		-e 's/-O3//' \
		-e 's/-Wp,-D_FORTIFY_SOURCE=2//' \
		-e '/-flto/d' \
		src/makefile || die
}

src_configure() {
	# bug #776799
	sed -i -e "s/-lcurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" src/makefile || die
}

src_compile() {
	append-cflags -std=c11

	emake -C src CC="$(tc-getCC)" \
		NE_GLOBAL_DIR="/usr/share/${PN}" \
		OPTS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		"${PN}"
}

src_install() {
	dobin src/${PN}

	insinto /usr/share/${PN}/syntax
	doins syntax/*.jsf

	doman doc/${PN}.1
	dodoc CHANGES README.md NEWS doc/*.{txt,pdf,texinfo} doc/default.*
}
