# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-EN-NameParse/Lingua-EN-NameParse-1.330.0.ebuild,v 1.1 2015/07/11 20:19:05 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=KIMRYAN
MODULE_VERSION=1.33
inherit perl-module

DESCRIPTION="routines for manipulating a person's name"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parse-RecDescent-1
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.940.0
		>=dev-perl/Test-Pod-1.40.0
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do parallel"
