# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MAKAMAKA
MODULE_VERSION=1.33
inherit perl-module

DESCRIPTION="Manipulate comma-separated value strings"

SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 x86"
IUSE="test"

RDEPEND=""
DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files t/00_pod.t
	perl-module_src_test
}
