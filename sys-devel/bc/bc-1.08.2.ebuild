# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="https://www.gnu.org/software/bc/bc.html"
SRC_URI="mirror://gnu/bc/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="libedit readline static"

RDEPEND="
	!readline? ( libedit? ( dev-libs/libedit:= ) )
	readline? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	app-alternatives/yacc
"
PDEPEND="app-alternatives/bc"

src_configure() {
	local myconf=(
		$(use_with readline)
		--program-suffix=-reference
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

	# configure dies with other lexes:
	# "configure: error: readline works only with flex."
	export LEX=flex

	econf "${myconf[@]}"

	# Do not regen docs -- configure produces a small fragment that includes
	# the version info which causes all pages to regen (newer file). Bug #554774
	touch -r doc doc/* || die
}

src_compile() {
	emake AR="$(tc-getAR)"
}

pkg_postinst() {
	# ensure to preserve the symlinks before app-alternatives/bc
	# is installed
	local x
	for x in bc dc ; do
		if [[ ! -h ${EROOT}/usr/bin/${x} ]] ; then
			ln -s "${x}-reference" "${EROOT}/usr/bin/${x}" || die
		fi
	done
}
