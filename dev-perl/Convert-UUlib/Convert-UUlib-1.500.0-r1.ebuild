# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=1.5
inherit perl-module

DESCRIPTION="A Perl interface to the uulib library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="system-uulib test"

RDEPEND="
	system-uulib? ( >=dev-libs/uulib-0.5.20-r1 )
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/Canary-Stability
"

SRC_TEST="do parallel"

src_prepare() {
	if use system-uulib; then
		epatch "${FILESDIR}/${P}-unbundle.patch"
		ewarn "Building with USE=system-uulib known to be problematic and cause"
		ewarn " Convert::UUlib to segfault when used. ( Bug #559930 )"
		use test || ewarn "use of FEATURES=test strongly recommended";
	fi
	perl-module_src_prepare
}
