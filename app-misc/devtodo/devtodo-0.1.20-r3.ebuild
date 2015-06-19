# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/devtodo/devtodo-0.1.20-r3.ebuild,v 1.8 2015/02/12 13:43:55 armin76 Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils bash-completion-r1 eutils flag-o-matic toolchain-funcs

DESCRIPTION="A nice command line todo list for developers"
HOMEPAGE="http://swapoff.org/DevTodo"
SRC_URI="http://swapoff.org/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="
	>=sys-libs/ncurses-5.2
	>=sys-libs/readline-4.1"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog QuickStart README doc/scripts.sh doc/scripts.tcsh doc/todorc.example )

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.diff
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-bashcom_spaces.patch
)

src_prepare() {
	# fix regex.h issue on case-insensitive file-systems #332235
	sed \
		-e 's/Regex.h/DTRegex.h/' \
		-i util/Lexer.h util/Makefile.{am,in} util/Regex.cc || die
	mv util/{,DT}Regex.h || die

	sed \
		-e "/^LIBS/s:$: $($(tc-getPKG_CONFIG) --libs ncursesw):g" \
		-i src/Makefile.am  || die

	autotools-utils_src_prepare
}

src_configure() {
	replace-flags -O[23] -O1

	local myeconfargs=(
		--sysconfdir="${EPREFIX}/etc/devtodo"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	newbashcomp contrib/${PN}.bash-completion ${PN}
	rm contrib/${PN}.bash-completion || die 'rm failed'

	bashcomp_alias devtodo tda tdd tde tdr todo

	dodoc -r contrib
}

pkg_postinst() {
	elog "Because of a conflict with app-misc/tdl, the tdl symbolic link"
	elog "and manual page have been removed."
}
