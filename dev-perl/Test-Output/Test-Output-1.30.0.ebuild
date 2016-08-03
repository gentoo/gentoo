# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="Utilities to test STDOUT and STDERR messages"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	>=dev-perl/Capture-Tiny-0.170.0
	>=virtual/perl-File-Temp-0.170.0
	dev-perl/Sub-Exporter
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do

src_test() {
	# Bug 584238 Avoidance
	if perl -e 'exit ( eval { require Test::Tester; Test::Tester->VERSION(0.107); 1 } ? 0 : 1 )'; then
		perl-module_src_test
	else
		einfo "Test phase skipped: Test::Tester required for tests"
		einfo "Please upgrade to >=dev-lang/perl-5.22.0 or >=virtual/perl-Test-Simple-1.1.10"
		einfo "if you want this tested"
	fi
}
