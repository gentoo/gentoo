# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STEFFENW
DIST_VERSION=1.001
inherit perl-module

DESCRIPTION="Tying a subroutine, function or method to a hash"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"

RDEPEND="dev-perl/Params-Validate"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Differences-0.600.0
		dev-perl/Test-NoWarnings
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod.t t/pod_coverage.t t/perl_critic.t \
		t/prereq_build.t
	perl-module_src_test
}
