# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Perl-Releases/CPAN-Perl-Releases-2.100.0.ebuild,v 1.1 2015/03/14 13:12:07 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=BINGOS
MODULE_VERSION=2.10
inherit perl-module

DESCRIPTION='Mapping Perl releases on CPAN to the location of the tarballs'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.470.0
	)
"

SRC_TEST="do parallel"
