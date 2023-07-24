# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KILINRAX
DIST_VERSION=2.12
inherit perl-module

DESCRIPTION="Extension for stripping HTML markup from text"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ppc64 ~sparc x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/400_kwalitee.t t/410_pod.t t/420_pod_coverage.t
	perl-module_src_test
}
