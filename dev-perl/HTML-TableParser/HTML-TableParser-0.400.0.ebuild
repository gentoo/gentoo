# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-TableParser/HTML-TableParser-0.400.0.ebuild,v 1.1 2015/06/27 14:59:54 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DJERIUS
MODULE_VERSION=0.40
inherit perl-module

DESCRIPTION="Extract data from an HTML table"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/HTML-Parser-3.260.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	virtual/perl-CPAN-Meta
	test? (
		>=virtual/perl-Test-Simple-0.320.0
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do parallel"
