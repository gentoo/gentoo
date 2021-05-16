# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JROCKWAY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="create a temporary database from a DBIx::Class::Schema"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Temp
	>=dev-perl/DBD-SQLite-1.290.0
	dev-perl/SQL-Translator
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/DBIx-Class
		>=virtual/perl-Test-Simple-1.1.10
	)
"
PERL_RM_FILES=("MYMETA.json" "MYMETA.yml") # https://rt.cpan.org/Ticket/Display.html?id=108141

PATCHES=(
	"${FILESDIR}/${PN}-0.05-no-dot-inc.patch"
)
