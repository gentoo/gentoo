# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MIROD
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="A re-usable XPath engine for DOM-like trees"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
