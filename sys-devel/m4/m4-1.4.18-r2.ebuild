# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU macro processor"
HOMEPAGE="https://www.gnu.org/software/m4/m4.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

# remember: cannot dep on autoconf since it needs us
BDEPEND="app-arch/xz-utils"

PATCHES=(
	"${FILESDIR}"/${P}-darwin17-printf-n.patch
	"${FILESDIR}"/${P}-glibc228.patch #663924
)

src_configure() {
	local -a myeconfargs=(
		--enable-changeword

		# Disable automagic dependency over libsigsegv; see bug #278026
		ac_cv_libsigsegv=no
	)

	[[ ${USERLAND} != GNU ]] && myeconfargs+=( --program-prefix=g )

	econf "${myeconfargs[@]}"
}

src_test() {
	[[ -d /none ]] && die "m4 tests will fail with /none/" #244396
	emake check
}

src_install() {
	default
	# autoconf-2.60 for instance, first checks gm4, then m4.  If we don't have
	# gm4, it might find gm4 from outside the prefix on for instance Darwin
	use prefix && dosym m4 /usr/bin/gm4
	if use examples ; then
		dodoc -r examples
		rm -f "${ED}"/usr/share/doc/${PF}/examples/Makefile*
	fi
}
