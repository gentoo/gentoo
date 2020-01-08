# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=2.21
inherit perl-module

DESCRIPTION="Populates HTML Forms with data"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/HTML-Parser
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/CGI )
"
# the dep specs are rather incomplete

SRC_TEST="do parallel"
