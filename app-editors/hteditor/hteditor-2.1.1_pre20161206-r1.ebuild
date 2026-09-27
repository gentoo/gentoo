# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

MY_P=${P/editor}

DESCRIPTION="File viewer, editor and analyzer for text, binary, and executable files"
HOMEPAGE="https://hte.sourceforge.net/ https://github.com/sebastianbiallas/ht/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P/_pre*}

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="X"

RDEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libX11 )
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	app-alternatives/yacc
	app-alternatives/lex"

DOCS=( AUTHORS ChangeLog KNOWNBUGS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-gcc-6-uchar.patch
	"${FILESDIR}"/${PN}-2.1.0-yylex.patch
)

src_configure() {
	# stdscr lives in libtinfo; HT_LIBS must include it (replaces configure.ac patch)
	append-libs -ltinfo
	append-cflags -std=gnu89

	econf \
		$(use_enable X x11-textmode) \
		--disable-maintainermode
}

src_install() {
	chmod u+x "${S}/install-sh"

	local HTML_DOCS="doc/*.html"
	doinfo doc/*.info

	default
}
