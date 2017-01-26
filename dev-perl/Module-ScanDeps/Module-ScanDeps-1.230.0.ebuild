# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RSCHUPP
DIST_VERSION=1.23
inherit perl-module

DESCRIPTION="Recursively scan Perl code for dependencies"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-Module-Metadata
	virtual/perl-Text-ParseWords
	virtual/perl-version
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/prefork
		dev-perl/Module-Pluggable
		dev-perl/Test-Requires
	)
"

src_test() {
	perl_rm_files t/0-pod.t
	perl-module_src_test
}
