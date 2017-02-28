# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.09
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A simple command-line shell framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	>=virtual/perl-Getopt-Long-2.360.0
	virtual/perl-IO
	dev-perl/TermReadKey
	virtual/perl-Term-ReadLine
	dev-perl/Text-Autoformat
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/author-pod-syntax.t t/cpan-changes.t t/release-cpan-changes.t t/pod.t \
		t/release-kwalitee.t t/release-trailing-space.t t/style-trailing-space.t
	perl-module_src_test
}
