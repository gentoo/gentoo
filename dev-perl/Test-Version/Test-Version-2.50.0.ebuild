# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=2.05
inherit perl-module

DESCRIPTION="Check to see that version's in modules are sane"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/File-Find-Rule-Perl
	>=virtual/perl-Module-Metadata-1.0.20
	>=virtual/perl-Test-Simple-0.940.0
	virtual/perl-parent
	>=virtual/perl-version-0.860.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Exception
	)
"
