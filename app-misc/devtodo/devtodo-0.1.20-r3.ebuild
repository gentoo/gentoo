# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 flag-o-matic

DESCRIPTION="A nice command line todo list for developers"
HOMEPAGE="http://swapoff.org/DevTodo"
SRC_URI="http://swapoff.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=sys-libs/ncurses-5.2:0=
	>=sys-libs/readline-4.1:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog QuickStart README doc/scripts.sh doc/scripts.tcsh doc/todorc.example )

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-bashcom_spaces.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# fix regex.h issue on case-insensitive file-systems #332235
	sed \
		-e 's/Regex.h/DTRegex.h/' \
		-i util/Lexer.h util/Makefile.{am,in} util/Regex.cc || die
	mv util/{,DT}Regex.h || die

	sed \
		-e "/^LIBS/s:$: $($(tc-getPKG_CONFIG) --libs ncurses):g" \
		-i src/Makefile.am  || die

	eautoreconf
}

src_configure() {
	replace-flags -O[23] -O1

	local myeconfargs=(
		--sysconfdir="${EPREFIX}/etc/devtodo"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newbashcomp contrib/${PN}.bash-completion ${PN}
	rm contrib/${PN}.bash-completion || die 'rm failed'

	bashcomp_alias devtodo tda tdd tde tdr todo

	dodoc -r contrib
}

pkg_postinst() {
	elog "Because of a conflict with app-misc/tdl, the tdl symbolic link"
	elog "and manual page have been removed."
}
