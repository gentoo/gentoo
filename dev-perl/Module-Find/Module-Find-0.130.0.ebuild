# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CRENZ
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Find and use installed modules in a (sub)category"

SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t t/meta.t t/pod-coverage.t
	perl-module_src_test
}
