# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RGARCIA
MODULE_VERSION=0.17
inherit perl-module

DESCRIPTION="A library to test long strings"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="virtual/perl-Test-Simple"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
