# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=EHUELS
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Ensure that your dependency listing is complete"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

PATCHES=( "${FILESDIR}/${PV}-require-ok.patch" )
RDEPEND="
	dev-perl/rpm-build-perl
	virtual/perl-CPAN-Meta
	dev-perl/File-Find-Rule-Perl
	virtual/perl-Module-CoreList
	dev-perl/Pod-Strip
"
DEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.980.0
	)
"
