# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=2.228
inherit perl-module

DESCRIPTION="Mail sorting/delivery module for Perl"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/File-HomeDir-0.610.0
	virtual/perl-File-Path
	virtual/perl-File-Spec
	dev-perl/File-Tempdir
	dev-perl/MIME-tools
	>=dev-perl/MailTools-1.15
	dev-perl/Mail-POP3Client
	dev-perl/Parse-RecDescent
	virtual/perl-parent
"

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( >=virtual/perl-Test-Simple-0.960.0 )
"
