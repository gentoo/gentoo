# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOY
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="safely and cleanly create closures via string eval"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

# Scalar::Util -> Scalar-List-Utils
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	!minimal? (
		>=dev-perl/Devel-LexAlias-0.50.0
		dev-perl/Perl-Tidy
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
