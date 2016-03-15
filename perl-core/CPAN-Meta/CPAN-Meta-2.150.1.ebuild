# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=2.150001
inherit perl-module

DESCRIPTION="The distribution metadata for a CPAN dist"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	>=virtual/perl-CPAN-Meta-YAML-0.8.0
	virtual/perl-Carp
	>=virtual/perl-JSON-PP-2.272.0
	>=virtual/perl-Parse-CPAN-Meta-1.441.400
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-version-0.880.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		>=virtual/perl-File-Temp-0.200.0
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.880.0
	)
"
