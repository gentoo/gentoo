# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RSCHUPP
DIST_VERSION=1.015
inherit perl-module

DESCRIPTION="Perl Archive Toolkit"

SLOT="0"
KEYWORDS="amd64 ~x86 ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/Archive-Zip-1.00
	>=virtual/perl-AutoLoader-5.660.200
	>=virtual/perl-Digest-SHA-5.450.0
	>=virtual/perl-File-Temp-0.50.0
	>=virtual/perl-IO-Compress-1.300.0
	>=dev-perl/PAR-Dist-0.320.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	perl_rm_files 't/00-pod.t'
	perl-module_src_test
}
