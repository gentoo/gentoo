# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/syntax/syntax-0.4.0.ebuild,v 1.1 2015/02/21 22:16:22 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PHAYLON
MODULE_VERSION=0.004
inherit perl-module

DESCRIPTION="Activate syntax extensions"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Data-OptList-0.104.0
	dev-perl/namespace-clean
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"
