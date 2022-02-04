# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOY
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="Easy subclassing of non-Moose classes"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/List-MoreUtils
	dev-perl/Module-Runtime
	>=dev-perl/Moose-2.0.0
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
	)
"
