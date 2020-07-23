# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RRWO
DIST_VERSION=v1.1.2
inherit perl-module

DESCRIPTION="Intelligently generate a README file from POD"

SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		dev-perl/Pod-Markdown
		dev-perl/Pod-Simple-LaTeX
		dev-perl/Type-Tiny-XS
		virtual/perl-podlators
	)
	>=dev-perl/CPAN-Changes-0.300.0
	virtual/perl-CPAN-Meta
	virtual/perl-Carp
	>=dev-perl/Class-Method-Modifiers-2.0.0
	virtual/perl-Exporter
	>=virtual/perl-ExtUtils-MakeMaker-6.560.0
	dev-perl/File-Slurp
	dev-perl/Getopt-Long-Descriptive
	virtual/perl-IO
	virtual/perl-Module-CoreList
	virtual/perl-Module-Load
	>=dev-perl/Moo-1.4.5
	dev-perl/MooX-HandlesVia
	>=dev-perl/Path-Tiny-0.18.0
	virtual/perl-Pod-Simple
	dev-perl/Role-Tiny
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Try-Tiny
	dev-perl/Type-Tiny
	dev-perl/namespace-autoclean
	>=virtual/perl-version-0.770.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	virtual/perl-File-Temp
	test? (
		dev-perl/IO-String
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
