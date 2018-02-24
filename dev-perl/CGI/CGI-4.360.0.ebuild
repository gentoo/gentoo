# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LEEJO
DIST_VERSION=4.36
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Simple Common Gateway Interface Class"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-0.820.0
	>=virtual/perl-File-Temp-0.170.0
	>=dev-perl/HTML-Parser-3.690.0
	virtual/perl-if
	>=virtual/perl-parent-0.225.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		>=dev-perl/Test-Deep-0.110.0
		dev-perl/Test-NoWarnings
		>=virtual/perl-Test-Simple-0.980.0
		>=dev-perl/Test-Warn-0.300.0
	)
"

src_test() {
	perl_rm_files t/compiles_pod.t t/changes.t
	perl-module_src_test
}
