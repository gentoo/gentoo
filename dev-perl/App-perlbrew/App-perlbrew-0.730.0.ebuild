# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/App-perlbrew/App-perlbrew-0.730.0.ebuild,v 1.1 2015/04/12 18:49:36 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=GUGOD
MODULE_VERSION=0.73
inherit perl-module

DESCRIPTION='Manage perl installations in your $HOME'
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CPAN-Perl-Releases-1.940.0
	>=dev-perl/Capture-Tiny-0.250.0
	>=dev-perl/Devel-PatchPerl-1.280.0
	>=virtual/perl-Pod-Parser-1.620.0
	>=dev-perl/local-lib-2.0.14
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-File-Temp-0.230.400
	>=dev-perl/IO-All-0.510.0
	>=dev-perl/Path-Class-0.330.0
	test? (
		>=dev-perl/Test-Exception-0.320.0
		>=virtual/perl-Test-Simple-1.1.2
		>=dev-perl/Test-NoWarnings-1.40.0
		>=dev-perl/Test-Output-1.30.0
		>=dev-perl/Test-Spec-0.470.0
	)
"

SRC_TEST="do parallel"
