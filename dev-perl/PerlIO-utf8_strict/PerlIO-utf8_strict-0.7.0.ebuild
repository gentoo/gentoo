# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=LEONT
DIST_VERSION=0.007
inherit perl-module

DESCRIPTION="Fast and correct UTF-8 IO"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"
# r: strict, warnings -> perl
RDEPEND="
	virtual/perl-XSLoader
"
# t: File::Spec::Functions -> File-Spec
# t: IO::File -> IO
# t: utf8 -> perl
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Carp
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Exception
		>=virtual/perl-Test-Simple-0.880.0
	)
"
src_compile() {
	emake OPTIMIZE="${CFLAGS}"
}
