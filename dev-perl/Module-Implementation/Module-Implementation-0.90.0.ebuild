# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Loads one of several alternate underlying implementations for a module"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Module-Runtime-0.12.0
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Requires
		>=dev-perl/Test-Fatal-0.6.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
src_test() {
	perl_rm_files "t/release-"* "t/author-"*
	perl-module_src_test
}
