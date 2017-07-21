# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OSFAMERON
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="Generate (possibly exuberant) Ctags style tags for Perl sourcecode"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test minimal"

PATCHES=(
	"${FILESDIR}/vim_noplugin.patch" # https://rt.cpan.org/Ticket/Display.html?id=105899
)
PERL_RM_FILES=(
	"README.pod" # https://rt.cpan.org/Ticket/Display.html?id=113166
)
RDEPEND="
	dev-perl/File-Find-Rule
	virtual/perl-Data-Dumper
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/Module-Locate
	dev-perl/Path-Tiny
	virtual/perl-parent
	!minimal? (
		dev-perl/PPI
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/Capture-Tiny
		dev-perl/Test-Exception
		dev-perl/Test-LongString
		>=virtual/perl-Test-Simple-0.420.0
		!minimal? (
			app-editors/vim[perl]
		)
	)
"

DIST_TEST=skip
# the tests work in principle, but they mess up the terminal badly

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
