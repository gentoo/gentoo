# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JROCKWAY
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="create a temporary database from a DBIx::Class::Schema"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-File-Temp
	>=dev-perl/DBD-SQLite-1.29
	dev-perl/SQL-Translator
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/DBIx-Class
		virtual/perl-Test-Simple
		>=virtual/perl-Test-Simple-1.1.10
	)
"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
