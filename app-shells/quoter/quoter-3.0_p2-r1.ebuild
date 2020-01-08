# Copyright 2016-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Quote arguments or standard input for usage in POSIX shell by eval"
HOMEPAGE="https://github.com/vaeth/quoter/"
SRC_URI="https://github.com/vaeth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" install

	rm -f "${ED}"/usr/bin/quoter_pipe.sh || die
	insinto /usr/share/${PN}
	doins bin/quoter_pipe.sh
}
