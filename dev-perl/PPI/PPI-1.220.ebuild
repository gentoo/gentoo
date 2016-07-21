# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MITHALDU
MODULE_VERSION=1.220
inherit perl-module

DESCRIPTION="Parse, Analyze and Manipulate Perl (without perl)"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.20
	>=dev-perl/Params-Util-1.00
	>=dev-perl/Clone-0.30
	>=virtual/perl-Digest-MD5-2.35
	dev-perl/IO-String
	>=dev-perl/List-MoreUtils-0.16
	>=virtual/perl-Storable-2.17"
DEPEND="${RDEPEND}
	test? ( >=dev-perl/File-Remove-1.42
		>=virtual/perl-Test-Simple-0.86
		>=dev-perl/Test-NoWarnings-0.084
		>=virtual/perl-File-Spec-0.84
		dev-perl/Test-SubCalls
		dev-perl/Test-Object
		>=dev-perl/Class-Inspector-1.22 )"

SRC_TEST="do"
