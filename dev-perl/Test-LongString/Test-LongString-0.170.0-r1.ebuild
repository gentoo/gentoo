# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RGARCIA
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="A library to test long strings"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="virtual/perl-Test-Simple"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
