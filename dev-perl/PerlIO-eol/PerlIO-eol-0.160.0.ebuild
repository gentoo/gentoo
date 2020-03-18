# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="PerlIO layer for normalizing line endings"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
# https://rt.cpan.org/Ticket/Display.html?id=123943
PERL_RM_FILES=(
	'Changes~'
	'LICENSE~'
	'README~'
	'dist.ini~'
	'eol.xs~'
	'lib/PerlIO/eol.pm~'
)
