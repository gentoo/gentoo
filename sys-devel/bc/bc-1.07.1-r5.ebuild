# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="https://www.gnu.org/software/bc/bc.html"
SRC_URI="mirror://gnu/bc/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit readline static"

RDEPEND="
	!readline? ( libedit? ( dev-libs/libedit:= ) )
	readline? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/yacc"

PATCHES=( "${FILESDIR}"/${PN}-1.07.1-no-ed-its-sed.patch )

src_prepare() {
	default

	# Avoid bad build tool usage when cross-compiling. Bug #627126
	tc-is-cross-compiler && eapply "${FILESDIR}"/${PN}-1.07.1-use-system-bc.patch
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

	# The libedit code isn't compatible currently. #830101
	use libedit && append-flags -fcommon

	# AC_SYS_LARGEFILE in configure.ac would handle this, but we don't patch
	# autotools otherwise currently.  This change has been sent upstream, but
	# who knows when they'll make another release.
	append-lfs-flags

	econf "${myconf[@]}"

	# Do not regen docs -- configure produces a small fragment that includes
	# the version info which causes all pages to regen (newer file). Bug #554774
	touch -r doc doc/* || die
}

src_compile() {
	emake AR="$(tc-getAR)"
}
