# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BINGOS
DIST_VERSION=2.30
inherit perl-module

DESCRIPTION="A Perl module for creation and manipulation of tar files"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-File-Spec-0.820.0
	>=virtual/perl-IO-Compress-2.15.0
	>=virtual/perl-IO-Zlib-1.10.0
"
DEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Harness-2.260.0
		virtual/perl-Test-Simple
	)
"
# TODO
# Consider adding some sort of system for turning this stuff on, the
# ENV vars GENTOO_TAR_BZIP2 and GENTOO_TAR_PTARDIFF exist for expert users,
# but we can't regulate it by USE flags without creating a circular
# dependency, specifically, the kind of circular dependency that
# prohibits dev-lang/perl depending on virtual/perl-Archive-Tar
# depending on perl-core/Archive-Tar, due to needing dev-perl/Text-Diff
# that *will not be present* during perl upgrade.
PATCHES=(
	"${FILESDIR}/${PN}-2.30-makefileptar.patch"
)
PERL_RM_FILES=(
	"t/99_pod.t"
)
