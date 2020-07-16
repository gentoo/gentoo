# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EHUELS
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="Ensure that your dependency listing is complete"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-no-heavy.patch"
	"${FILESDIR}/${P}-backcompat-test-more.patch"
)
RDEPEND="
	virtual/perl-CPAN-Meta
	dev-perl/File-Find-Rule-Perl
	virtual/perl-Module-CoreList
	dev-perl/Pod-Strip
"
DEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
pkg_postinst() {
	einfo 'Test::Dependencies::Heavy is now defunct in this release.'
	einfo 'Read `perldoc Test::Dependencies::Heavy` for details.'
}
