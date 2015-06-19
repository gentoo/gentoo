# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Sub/Tie-Sub-1.1.0-r1.ebuild,v 1.1 2014/08/26 17:58:57 axs Exp $

EAPI=5

MODULE_AUTHOR=STEFFENW
MODULE_VERSION=1.001
inherit perl-module

DESCRIPTION="Tying a subroutine, function or method to a hash"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Params-Validate"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Differences-0.600.0
		dev-perl/Test-NoWarnings
		dev-perl/Test-Exception
		>=dev-perl/Test-Pod-1.140.0
		>=dev-perl/Test-Pod-Coverage-1.40.0
		virtual/perl-Test-Simple
	)"

SRC_TEST="do"
