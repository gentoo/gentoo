# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=2.07
inherit perl-module

DESCRIPTION="Convert plain text to HTML"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# Email::Find::addrspec -> Email-Find 0.09
# HTML::Entities -> HTML-Parser
# Scalar::Util -> Scalar-List-Utils
# test: File::Find -> perl
RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Email-Find-0.90.0
	>=virtual/perl-Exporter-5.58
	>=dev-perl/HTML-Parser-1.260.0
	>=virtual/perl-Scalar-List-Utils-1.120.0
	>=virtual/perl-Text-Tabs+Wrap-98.112.800
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
	)
"
