# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CFAERBER
DIST_VERSION=1.100
inherit perl-module

DESCRIPTION="A Stringprep Profile for User Names and Passwords (RFC 4013)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Unicode-Stringprep-1
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"
src_test() {
	perl_rm_files t/10pod.t t/11pod_cover.t
	perl-module_src_test
}
