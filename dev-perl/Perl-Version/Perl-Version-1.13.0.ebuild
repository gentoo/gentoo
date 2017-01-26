# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.013
inherit perl-module

DESCRIPTION="Parse and manipulate Perl version strings"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# r: Pod::Usage -> perl
# r: Scalar::Util -> Scalar-List-Utils
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	dev-perl/File-Slurp-Tiny
	>=virtual/perl-Getopt-Long-2.340.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/manifest.t t/pod-coverage.t t/pod.t
	perl-module_src_test
}
