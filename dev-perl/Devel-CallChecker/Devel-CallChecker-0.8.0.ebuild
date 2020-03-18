# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="Custom OP checking attached to subroutines"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/DynaLoader-Functions-0.1.0
	virtual/perl-Exporter
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=virtual/perl-ExtUtils-CBuilder-0.150.0
		virtual/perl-ExtUtils-ParseXS
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
