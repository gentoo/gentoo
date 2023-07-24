# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CORION
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Framework to automate HTML forms"

SLOT="0"
KEYWORDS="~amd64 ~sparc x86"

RDEPEND="
	>=dev-perl/Data-Random-0.50.0
	dev-perl/HTML-Form
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-MockObject
		virtual/perl-Test-Simple
	)
"
