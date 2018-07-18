# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=LEONT
DIST_VERSION=0.007
inherit perl-module

DESCRIPTION="Fast and correct UTF-8 IO"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ~ppc64 ~s390 ~sparc x86"
IUSE="test"
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
