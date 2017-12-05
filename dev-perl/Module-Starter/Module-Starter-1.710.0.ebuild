# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=XSAWYERX
MODULE_VERSION=1.60
inherit perl-module

DESCRIPTION="A simple starter kit for any module"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/Module-Install-AuthorTests
	dev-perl/Path-Class
	>=virtual/perl-Pod-Parser-1.210.0
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
		>=virtual/perl-Test-Harness-0.210.0
	)
"

SRC_TEST="do parallel"
