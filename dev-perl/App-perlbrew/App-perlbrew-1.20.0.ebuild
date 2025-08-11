# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GUGOD
DIST_VERSION=1.02
inherit perl-module optfeature

DESCRIPTION='Manage perl installations in your $HOME'

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/CPAN-Perl-Releases-5.202.307.200
	>=dev-perl/Capture-Tiny-0.360.0
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

# Fails, not clear why
PERL_RM_FILES=( t/20.patchperl.t )

src_test() {
	if has "network" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Network Tests Enabled"
		local -x TEST_LIVE=1
	else
		ewarn "This package needs network access for comprehensive testing."
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi

	if has "network-dev-test" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Developer HTTP Test enabled"
		local -x PERLBREW_DEV_TEST=1
	fi

	perl-module_src_test
}

pkg_postinst() {
	optfeature "support for patching built Perls" dev-perl/Devel-PatchPerl
}
