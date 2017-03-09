# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Roles which support overloading"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x64-macos"
IUSE="test"

RDEPEND="
	>=dev-perl/Moose-0.940.0
	dev-perl/aliased
	>=dev-perl/namespace-autoclean-0.160.0
	dev-perl/namespace-clean
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-if
	)
"

SRC_TEST="do"
