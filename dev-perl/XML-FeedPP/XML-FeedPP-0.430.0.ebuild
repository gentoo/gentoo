# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=0.43
DIST_AUTHOR=KAWASAKI
inherit perl-module

DESCRIPTION="Parse/write/merge/edit RSS/RDF/Atom syndication feeds"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/XML-TreePP-0.390.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
