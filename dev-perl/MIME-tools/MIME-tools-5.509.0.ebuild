# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DSKOLL
DIST_VERSION=5.509
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A Perl module for parsing and creating MIME entities"

SLOT="0"
KEYWORDS="alpha amd64 ~arm64 ~hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

RDEPEND="
	>=virtual/perl-File-Path-1
	>=virtual/perl-File-Spec-0.600.0
	>=virtual/perl-File-Temp-0.180.0
	virtual/perl-IO
	>=virtual/perl-MIME-Base64-2.200.0
	dev-perl/MailTools
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Deep
	)
"
# tests fail when done in parallel
DIST_TEST="do"

src_test() {
	perl_rm_files t/02-kwalitee.t t/02-pod-coverage.t t/02-pod.t
	perl-module_src_test
}
