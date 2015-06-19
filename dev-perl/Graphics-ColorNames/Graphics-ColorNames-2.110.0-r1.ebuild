# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Graphics-ColorNames/Graphics-ColorNames-2.110.0-r1.ebuild,v 1.2 2015/06/13 21:40:26 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RRWO
MODULE_VERSION=2.11
inherit perl-module

DESCRIPTION="Defines RGB values for common color names"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="recommended"

COMMON_DEPEND="
	virtual/perl-File-Spec
	virtual/perl-IO
	>=virtual/perl-Module-Load-0.10
	virtual/perl-Module-Loaded
	recommended? (
		>=dev-perl/Color-Library-0.02
		dev-perl/Tie-Sub
		dev-perl/Test-Pod-Coverage
		>=dev-perl/Test-Pod-1.00
		dev-perl/Test-Portability-Files
		>=dev-perl/Pod-Readme-0.09
	)
"
DEPEND="
	${COMMON_DEPEND}
	dev-perl/Test-Exception
	virtual/perl-Test-Simple
	dev-perl/Module-Build
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"
