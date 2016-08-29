# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Make sure you didn't emit any warnings while testing"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="virtual/perl-Test-Simple"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_test() {
	# Bug 584238 Avoidance
	if perl -e 'exit ( eval { require Test::Tester; 1 } ? 0 : 1 )'; then
		perl-module_src_test
	else
		einfo "Test phase skipped: Test::Tester required for tests"
		einfo "Please upgrade to >=dev-lang/perl-5.22.0 or >=virtual/perl-Test-Simple-1.1.10"
		einfo "if you want this tested"
	fi
}
