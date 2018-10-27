# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.60
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="a basic framework for creating and maintaining RSS files"
HOMEPAGE="http://perl-rss.sourceforge.net/"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	dev-perl/HTML-Parser
	>=dev-perl/XML-Parser-2.230.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	"t/pod.t" "t/pod-coverage.t"
	"t/cpan-changes.t" "t/style-trailing-space.t"
)
