# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GUGOD
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION='Manage perl installations in your $HOME'

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-7.220.0
	>=dev-perl/CPAN-Perl-Releases-5.202.307.200
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
		>=dev-perl/Path-Class-0.330.0
		>=dev-perl/Test2-Plugin-IOEvents-0.1.1
		>=dev-perl/Test2-Plugin-NoWarnings-0.100.0
	)
"

mydoc=( "doc/notes.org" )

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
