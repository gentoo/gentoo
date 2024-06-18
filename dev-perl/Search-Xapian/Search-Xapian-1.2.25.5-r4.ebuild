# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OLLY
inherit perl-module toolchain-funcs

DESCRIPTION="Perl XS frontend to the Xapian C++ search library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/xapian-1.4:0=[inmemory(+)]
	!dev-libs/xapian-bindings[perl]"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Devel-Leak )
"

DIST_TEST=do
# parallel fails sometimes...

src_configure() {
	myconf="CXX=$(tc-getCXX) CXXFLAGS=${CXXFLAGS} CC=$(tc-getCXX)"
	perl-module_src_configure
}

src_install() {
	perl-module_src_install

	use examples && {
		docinto examples
		dodoc "${S}"/examples/*
	}
}
