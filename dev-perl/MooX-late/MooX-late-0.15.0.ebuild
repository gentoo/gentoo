# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooX-late/MooX-late-0.15.0.ebuild,v 1.3 2015/04/05 12:57:50 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TOBYINK
MODULE_VERSION=0.015
inherit perl-module

DESCRIPTION="Easily translate Moose code to Moo"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Moo-1.6.0
	>=dev-perl/Type-Tiny-1.0.1
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=dev-perl/Test-Fatal-0.10.0
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Requires-0.60.0
	)
"

SRC_TEST=do
