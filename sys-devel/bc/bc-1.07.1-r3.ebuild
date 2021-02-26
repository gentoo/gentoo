# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="https://www.gnu.org/software/bc/bc.html"
SRC_URI="mirror://gnu/bc/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit readline static"

RDEPEND="
	!readline? ( libedit? ( dev-libs/libedit:= ) )
	readline? (
		>=sys-libs/readline-4.1:0=
		>=sys-libs/ncurses-5.2:=
	)
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
	virtual/yacc
"

PATCHES=(
	"${FILESDIR}/${PN}-1.07.1-no-ed-its-sed.patch"
)

src_prepare() {
	default

	# Avoid bad build tool usage when cross-compiling.  #627126
	tc-is-cross-compiler && eapply "${FILESDIR}/${PN}-1.07.1-use-system-bc.patch"
}

src_configure() {
	local myconf=(
		$(use_with readline)
	)
	if use readline ; then
		myconf+=( --without-libedit )
	else
		myconf+=( $(use_with libedit) )
	fi
	use static && append-ldflags -static

	econf "${myconf[@]}"

	# Do not regen docs -- configure produces a small fragment that includes
	# the version info which causes all pages to regen (newer file). #554774
	touch -r doc doc/*
}

src_compile() {
	emake AR="$(tc-getAR)"
}
