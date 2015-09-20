# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIYAGAWA
MODULE_VERSION=1.0037
inherit perl-module

DESCRIPTION="Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Apache-LogFormat-Compiler-0.120.0
	>=dev-perl/Cookie-Baker-0.50.0
	>=dev-perl/Devel-StackTrace-1.230.0
	>=dev-perl/Devel-StackTrace-AsHTML-0.110.0
	>=dev-perl/File-ShareDir-1.0.0
	dev-perl/Filesys-Notify-Simple
	>=dev-perl/HTTP-Body-1.60.0
	>=dev-perl/HTTP-Headers-Fast-0.180.0
	>=dev-perl/HTTP-Message-5.814.0
	>=virtual/perl-HTTP-Tiny-0.34.0
	>=dev-perl/Hash-MultiValue-0.50.0
	>=virtual/perl-Pod-Parser-1.360.0
	>=dev-perl/Stream-Buffered-0.20.0
	>=dev-perl/Test-TCP-2.0.0
	dev-perl/Try-Tiny
	>=dev-perl/URI-1.590.0
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
	)
"

# SRC_TEST="do parallel"
# one test fails due to Perl 5.22 regex deprecation warnings :(
