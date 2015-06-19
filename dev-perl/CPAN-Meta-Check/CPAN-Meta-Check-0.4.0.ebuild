# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Meta-Check/CPAN-Meta-Check-0.4.0.ebuild,v 1.3 2013/09/09 11:46:09 pinkbyte Exp $

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.004
inherit perl-module

DESCRIPTION='Verify requirements in a CPAN::Meta object'

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-CPAN-Meta-2.120.920
	>=virtual/perl-CPAN-Meta-Requirements-2.120.920
	virtual/perl-Module-Metadata
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Differences
	)
"

SRC_TEST="do"
