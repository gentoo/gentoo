# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CJFIELDS
DIST_VERSION=1.70
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Regular expression-based Perl Parser for NCBI Entrez Gene"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-parent
	>=sci-biology/bioperl-1.6.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/release-{eol,mojibake,no-tabs,pod-{coverage,syntax}}.t
	perl-module_src_test
}
