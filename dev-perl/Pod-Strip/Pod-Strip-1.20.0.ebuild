# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-Strip/Pod-Strip-1.20.0.ebuild,v 1.2 2015/06/13 22:40:15 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DOMM
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Remove POD from Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Pod-Simple-3.0.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
