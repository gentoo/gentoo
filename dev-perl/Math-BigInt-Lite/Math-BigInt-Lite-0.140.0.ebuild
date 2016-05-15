# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="FLORA"
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="What BigInts are before they become big"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=virtual/perl-Math-BigInt-1.940.0
	>=virtual/perl-Math-BigRat-0.190.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? ( >=virtual/perl-Test-Simple-0.520.0 )"

src_test() {
	local bad_files=( "t/pod_cov.t" "t/pod.t" );
	einfo "t/bigintpm.t is broken: https://rt.cpan.org/Public/Bug/Display.html?id=75667";
	bad_files+=( "t/bigintpm.t" );
	perl_rm_files "${bad_files[@]}";

	perl-module_src_test;
}
