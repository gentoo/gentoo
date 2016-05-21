# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SISYPHUS
MODULE_VERSION=0.50
inherit perl-module

DESCRIPTION="Write Perl subroutines in other languages"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="test"

RDEPEND="virtual/perl-Digest-MD5
	virtual/perl-File-Spec
	dev-perl/Parse-RecDescent"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Warn
	)"

SRC_TEST=do

src_test() {
	MAKEOPTS+=" -j1" perl-module_src_test # bug 384137
}
