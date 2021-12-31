# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.26
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Build an optimized subroutine parameter validator once, use it forever"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
LICENSE="Artistic-2"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Eval-Closure
	dev-perl/Exception-Class
	virtual/perl-Exporter
	>=virtual/perl-Scalar-List-Utils-1.400.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=dev-perl/Specio-0.140.0
		>=virtual/perl-Test-Simple-1.302.15
		dev-perl/Test-Without-Module
		>=dev-perl/Test2-Suite-0.0.72
		dev-perl/Test2-Plugin-NoWarnings
	)
"
