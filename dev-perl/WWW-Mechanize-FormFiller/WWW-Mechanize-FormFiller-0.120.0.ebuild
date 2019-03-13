# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CORION
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Framework to automate HTML forms"

SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Data-Random-0.50.0
	dev-perl/HTML-Form
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-MockObject
		virtual/perl-Test-Simple
	)
"
