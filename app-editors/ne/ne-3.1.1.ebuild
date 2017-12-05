# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="the nice editor, easy to use for the beginner and powerful for the wizard"
HOMEPAGE="http://ne.di.unimi.it/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="tinfo"

DEPEND="sys-libs/ncurses:0=[tinfo?]"

RDEPEND="
	${DEPEND}
	dev-lang/perl
"

HTML_DOCS=( doc/html/. )

src_prepare() {
	default
	sed -i -e 's/-O3//' src/makefile || die
}

src_configure() {
	local sedflags="s|-lcurses|-lncurses|g"
	use tinfo && sedflags="s|-lcurses|-ltinfo|g"
	sed -i -e "${sedflags}" src/makefile || die
}

src_compile() {
	append-cflags -std=c11
	emake -C src CC="$(tc-getCC)" \
		NE_GLOBAL_DIR="/usr/share/${PN}" \
		OPTS="${CFLAGS}" \
		"${PN}"
}

src_install() {
	dobin "src/${PN}"

	insinto "/usr/share/${PN}/syntax"
	doins syntax/*.jsf

	doman "doc/${PN}.1"
	dodoc CHANGES README.md NEWS doc/*.{txt,pdf,texinfo} doc/default.*
}
