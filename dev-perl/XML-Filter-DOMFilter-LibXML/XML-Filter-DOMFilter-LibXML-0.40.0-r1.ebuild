# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHOROBA
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="SAX Filter allowing DOM processing of selected subtrees"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 sparc x86"

RDEPEND="
	>=dev-perl/XML-LibXML-1.530.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/XML-SAX-Writer
	)
"
