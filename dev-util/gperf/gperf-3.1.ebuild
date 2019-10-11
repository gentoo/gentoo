# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="A perfect hash function generator"
HOMEPAGE="https://www.gnu.org/software/gperf/"
SRC_URI="mirror://gnu/gperf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

src_prepare() {
	sed -i \
		-e "/^CPPFLAGS /s:=:+=:" \
		*/Makefile.in || die #444078

	eapply_user
}

src_configure() {
	econf --htmldir='$(datarootdir)/doc/'"${PF}/html"
}
