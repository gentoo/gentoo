# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=2.101465
inherit perl-module

DESCRIPTION="MVP config reader for .ini files"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Config-INI
	>=dev-perl/Config-MVP-2
	dev-perl/Moose
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
