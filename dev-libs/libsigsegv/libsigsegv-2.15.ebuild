# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Library for handling page faults in user mode"
HOMEPAGE="https://www.gnu.org/software/libsigsegv/"
SRC_URI="mirror://gnu/libsigsegv/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

src_configure() {
	econf --enable-shared

	if tc-is-cross-compiler && [[ ${CHOST} == sparc64* ]] ; then
		# Tries to use fault-linux-sparc-old.h otherwise which is
		# for non-POSIX systems (bug #833469)
		sed -i -e "s:fault-linux-sparc-old.h:fault-linux-sparc.h:" config.status config.h.in config.h || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	rm -f "${ED}/usr/$(get_libdir)"/*.la || die
	dodoc AUTHORS ChangeLog* NEWS PORTING README
}
