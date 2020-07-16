# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LEEJO
MODULE_VERSION=4.22
inherit perl-module

DESCRIPTION="Simple Common Gateway Interface Class"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-0.820.0
	virtual/perl-File-Temp
	>=dev-perl/HTML-Parser-3.690.0
	virtual/perl-if
	>=virtual/perl-parent-0.225.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Deep
		dev-perl/Test-Warn
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST="do parallel"
