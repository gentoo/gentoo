# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Interface to perls parser variables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/B-Hooks-OP-Check-0.180.0
	virtual/perl-XSLoader
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/B-Hooks-EndOfScope
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
