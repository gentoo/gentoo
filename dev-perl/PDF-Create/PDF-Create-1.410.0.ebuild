# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MANWAR
DIST_VERSION=1.41
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Create PDF documents in Perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="test examples"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	>=dev-perl/File-Share-0.250.0
	dev-perl/JSON
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/File-ShareDir-Install
	test? (
		virtual/perl-File-Temp
		>=dev-perl/Test-LeakTrace-0.140.0
		>=virtual/perl-Test-Simple-1.0.0
	)
"
src_test() {
	perl_rm_files "t/changes.t" "t/meta-json.t" "t/meta-yml.t" "t/pod.t" "t/manifest.t"
	perl-module_src_test
}
