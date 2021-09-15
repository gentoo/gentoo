# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOMM
DIST_VERSION=1.100
inherit perl-module

DESCRIPTION="Remove POD from Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/99_pod.t t/99_pod_coverage.t
	perl-module_src_test
}
