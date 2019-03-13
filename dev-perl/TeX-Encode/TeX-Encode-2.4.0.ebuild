# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ATHREEF
DIST_VERSION=2.004
inherit perl-module

DESCRIPTION="Encode/decode Perl utf-8 strings into TeX"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Encode-0.100.0
	>=dev-perl/HTML-Parser-3.670.0
	>=dev-perl/Pod-LaTeX-0.560.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.100.0
	)
"
