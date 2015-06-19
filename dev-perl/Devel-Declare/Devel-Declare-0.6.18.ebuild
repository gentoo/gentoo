# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Declare/Devel-Declare-0.6.18.ebuild,v 1.1 2015/05/09 19:26:49 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.006018
inherit perl-module

DESCRIPTION="Adding keywords to perl, in perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/B-Hooks-EndOfScope-0.50.0
	>=dev-perl/B-Hooks-OP-Check-0.190.0
	>=virtual/perl-Scalar-List-Utils-1.110.0
	dev-perl/Sub-Name
"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	test? (
		>=virtual/perl-Test-Simple-0.88
		dev-perl/Test-Requires
	)
"

SRC_TEST=do
