# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=2.09_02
inherit perl-module

DESCRIPTION="Work with ISBN as objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test xisbn barcode"

RDEPEND="
	xisbn?   ( dev-perl/Mojolicious )
	barcode? (
	    dev-perl/GD-Barcode
	    dev-perl/GD[png]
	)
	>=dev-perl/Business-ISBN-Data-20140910.2.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.950.0
	)
"

# NOTE: This version is shipped because upstream has broken everything
# by shipping an unmappable 2.010 which == 2.01 in both upstream versioning
# and perl->gentoo mapping rules.
#
# Dependencies taken from 2.010 because 2.09_02 lacks all dependencies.

src_prepare() {
	perl-module_src_prepare
	sed -i '/URI/d' Makefile.PL || die # unused dependency
}

src_test() {
	local my_test_control="${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}"
	local bad_tests=( t/pod{,_coverage}.t )
	if ! has network ${my_test_control}; then
		einfo "Disabling network tests without DIST_TEST_OVERRIDE =~ network"
		bad_tests+=( t/xisbn10.t )
	fi
	perl_rm_files "${bad_tests[@]}"
	perl-module_src_test
}
