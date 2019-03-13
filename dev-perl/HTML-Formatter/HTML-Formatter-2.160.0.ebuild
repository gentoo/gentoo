# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NIGELM
DIST_VERSION=2.16
inherit perl-module

DESCRIPTION="Base class for HTML Formatters"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	dev-perl/Font-AFM
	dev-perl/HTML-Tree
	virtual/perl-IO
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/File-Slurper
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Warnings
	)
"
src_test() {
	perl_rm_files t/author-* t/release-*
	perl-module_src_test
}
