# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GMCHARLT
inherit perl-module

DESCRIPTION="Perl extension for handling MARC records"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
