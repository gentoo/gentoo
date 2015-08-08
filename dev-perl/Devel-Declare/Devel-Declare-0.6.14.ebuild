# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.006014
inherit perl-module

DESCRIPTION="Adding keywords to perl, in perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Sub-Name
	virtual/perl-Scalar-List-Utils
	>=dev-perl/B-Hooks-OP-Check-0.190.0
	dev-perl/B-Hooks-EndOfScope
"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302
	test? (
		>=virtual/perl-Test-Simple-0.88
	)
"

SRC_TEST=do
