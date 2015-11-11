# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=NIGELM
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="Perl extension for scrubbing/sanitizing html"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/HTML-Parser"
DEPEND="${REPEND}
	test? (
		dev-perl/Test-Memory-Cycle
		dev-perl/Test-CPAN-Meta
		dev-perl/Test-NoTabs
		dev-perl/Test-EOL
	)"

SRC_TEST="do"
