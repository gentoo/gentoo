# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooseX-ConfigFromFile/MooseX-ConfigFromFile-0.110.0.ebuild,v 1.2 2014/12/13 23:26:27 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="An abstract Moose role for setting attributes from a configfile"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Moose-0.350.0
	dev-perl/MooseX-Getopt
	>=dev-perl/MooseX-Types-Path-Tiny-0.5.0
	dev-perl/Try-Tiny
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/Path-Class
		dev-perl/Path-Tiny
		dev-perl/Test-CheckDeps
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.420.0
		>=dev-perl/Test-NoWarnings-1.40.0
		dev-perl/Test-Requires
		dev-perl/Test-Without-Module
	)
"

SRC_TEST=do

src_test() {
	if has_version dev-perl/MooseX-SimpleConfig ; then
		perl-module_src_test
	else
		einfo "Tests disabled due to dependency cycle."
		einfo "Please install dev-perl/MooseX-SimpleConfig and rerun tests!"
	fi
}
