# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=TJMATHER
DIST_VERSION=1.45
inherit perl-module

DESCRIPTION="A Perl module for an DOM Level 1 compliant interface"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/libwww-perl
	>=dev-perl/XML-Parser-2.30
	dev-perl/XML-RegExp"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/libxml-perl-0.70.0
	)
"
