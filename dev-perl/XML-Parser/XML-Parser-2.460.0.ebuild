# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TODDR
DIST_VERSION=2.46
inherit perl-module multilib

DESCRIPTION="A perl module for parsing XML documents"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-libs/expat-1.95.1-r1
	dev-perl/libwww-perl
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	myconf="EXPATLIBPATH=${EPREFIX}/usr/$(get_libdir) EXPATINCPATH=${EPREFIX}/usr/include"
	perl-module_src_configure
}
