# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JROCKWAY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="create a temporary database from a DBIx::Class::Schema"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-File-Temp
	>=dev-perl/DBD-SQLite-1.290.0
	dev-perl/SQL-Translator
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/DBIx-Class
		>=virtual/perl-Test-Simple-1.1.10
	)
"
PERL_RM_FILES=("MYMETA.json" "MYMETA.yml") # https://rt.cpan.org/Ticket/Display.html?id=108141
