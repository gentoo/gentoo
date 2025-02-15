# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Make replacement"
HOMEPAGE="http://projects.camlcity.org/projects/omake.html"
SRC_URI="https://github.com/ocaml-omake/omake/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc fam ncurses +ocamlopt readline"
RESTRICT="installsources !ocamlopt? ( strip )"

DEPEND=">=dev-lang/ocaml-3.10.2:=[ocamlopt?]
	ncurses? ( >=sys-libs/ncurses-5.3:0= )
	fam? ( virtual/fam )
	readline? ( >=sys-libs/readline-4.3:0= )"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/ocaml-3.10.2"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.2-cflags.patch"
)

src_prepare() {
	default

	cat <<- EOF > .config.local || die
	# Install man pages into the correct location
	public.MANDIR = $'${EPREFIX}/usr/share/man'
	EOF

	# https://bugs.gentoo.org/722934
	sed -i -e "s/AR = ar/AR = $(tc-getAR)/" mk/osconfig_unix.mk || die
}

src_configure() {
	edo ./configure \
		-prefix "${EPREFIX}/usr" \
		$(usev !readline '-disable-readline') \
		$(usev !ncurses '-disable-ncurses') \
		$(usev !fam '-disable-fam')
}

src_compile() {
	emake all
}

src_test() {
	# C lexer tests fails with glibc and gcc headers
	# *** omake error:
	# File /usr/include/stdio.h: line 212, characters 27-28
	# Syntax error on token lbrack
	# Current state:
	# decl_specifiers_id_opt type_id . decl_specifiers_any_opt
	# The next possible tokens are: tyqual tyclass tymod __attribute__
	# *** failure
	rm -r test/parse/C/Test2 || die
	# *** omake error:
	# File /usr/lib/gcc/x86_64-pc-linux-gnu/15/include/stddef.h: line 427, characters 71-75
	# Syntax error on token tymod
	# Current state:
	# id lparen . args_opt rparen
	# The next possible tokens are: id lparen amp star string sizeof plus minus
	# __extension__ incop1 unop1 char float int
	# *** failure
	rm -r test/parse/C/Test3 || die
	# Shell test failure due to innocuous output change
	rm -r test/shell/Test2 || die

	edo ./src/main/omake check
	if find test -name result.log | xargs grep -q '^*** failure$'; then
		die "Some tests failed."
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc ChangeLog CONTRIBUTORS.org README.md
	if use doc; then
		dodoc doc/ps/omake-doc.pdf doc/txt/omake-doc.txt
		dodoc -r doc/html
	fi
}
