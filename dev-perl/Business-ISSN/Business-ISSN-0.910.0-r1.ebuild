# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=0.91
inherit perl-module

DESCRIPTION="Object and functions to work with International Standard Serial Numbers"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

src_install() {
	perl-module_src_install
	rm -rf "${ED}"/usr/share/man || die
}

src_test() {
	perl_rm_files t/pod.t t/pod_coverage.t t/prereq.t
	perl-module_src_test
}
