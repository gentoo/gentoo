# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GUGOD
DIST_VERSION=0.97
inherit perl-module

DESCRIPTION='Manage perl installations in your $HOME'

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-7.220.0
	>=dev-perl/CPAN-Perl-Releases-5.202.103.200
	>=dev-perl/Capture-Tiny-0.360.0
	>=dev-perl/Devel-PatchPerl-2.80.0
	>=virtual/perl-ExtUtils-MakeMaker-7.220.0
	>=virtual/perl-File-Temp-0.230.400
	virtual/perl-JSON-PP
	>=dev-perl/local-lib-2.0.14
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		>=dev-perl/File-Which-1.210.0
		>=dev-perl/IO-All-0.510.0
		>=dev-perl/Path-Class-0.330.0
		>=dev-perl/Test-Exception-0.320.0
		>=dev-perl/Test-NoWarnings-1.40.0
		>=dev-perl/Test-Output-1.30.0
		>=virtual/perl-Test-Simple-1.1.2
		>=dev-perl/Test-Spec-0.490.0
		>=dev-perl/Test-TempDir-Tiny-0.16.0
	)
"

mydoc=("doc/notes.org")

src_test() {
	( # export leak guard
		if has "network" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
			einfo "Network Tests Enabled"
			export TEST_LIVE=1
		else
			ewarn "This package needs network access for comprehensive testing."
			ewarn "For details, see:"
			ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
		fi
		if has "network-dev-test" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
			einfo "Developer HTTP Test enabled"
			export PERLBREW_DEV_TEST=1
		fi
		perl-module_src_test
	)
}
