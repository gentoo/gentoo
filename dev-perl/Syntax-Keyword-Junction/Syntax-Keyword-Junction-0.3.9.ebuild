# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.003009
inherit perl-module

DESCRIPTION="Perl6 style Junction operators in Perl5"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Sub-Exporter-Progressive-0.1.6
	dev-perl/syntax
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/Test-Needs-0.2.6
	)
"

PERL_RM_FILES=( "t/release-pod-syntax.t" )
