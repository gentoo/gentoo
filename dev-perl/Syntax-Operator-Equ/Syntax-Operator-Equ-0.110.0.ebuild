# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Equality operators that distinguish undef"

SLOT="0"
KEYWORDS="~amd64 ~x86"

# The infix operators require the PL_infix_plugin hook introduced by Perl 5.38.
# Older versions would only be able to make use of is_strequ() and is_numequ().
RDEPEND="
	>=dev-lang/perl-5.38
	>=dev-perl/meta-0.3.2
	>=dev-perl/XS-Parse-Keyword-0.470.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.400.400
	test? (
		virtual/perl-Test2-Suite
	)
"
