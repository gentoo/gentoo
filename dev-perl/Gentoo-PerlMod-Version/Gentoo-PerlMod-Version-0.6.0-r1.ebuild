# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gentoo-PerlMod-Version/Gentoo-PerlMod-Version-0.6.0-r1.ebuild,v 1.4 2015/06/13 22:49:08 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=KENTNL
MODULE_VERSION=0.6.0
inherit perl-module

DESCRIPTION="Convert arbitrary Perl Modules' versions into normalised Gentoo versions"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/List-MoreUtils
	dev-perl/Sub-Exporter
	>=virtual/perl-version-0.770.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.300
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.980.0
	)
"

SRC_TEST="do"
