# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALEXMV
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Extract probable dates from strings"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Data-Inheritable
	>=dev-perl/DateTime-Format-Natural-0.600.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/Test-MockTime
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
