# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PETDANCE
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="Tools to test taintedness"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=""
DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
