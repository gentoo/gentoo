# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHOUT
DIST_VERSION=1.53

inherit perl-module

DESCRIPTION="Expand template text with embedded Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter"

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-Safe
		dev-perl/Test-More-UTF8
		virtual/perl-Test-Simple
		dev-perl/Test-Warnings
	)"

PERL_RM_FILES=( "t/author-pod-syntax.t" "t/author-signature.t" )
