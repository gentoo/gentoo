# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Interface to perls parser variables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/B-Hooks-OP-Check-0.180.0"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		dev-perl/B-Hooks-EndOfScope
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
