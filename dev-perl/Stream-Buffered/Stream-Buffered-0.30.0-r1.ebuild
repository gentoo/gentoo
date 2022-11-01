# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOY
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Temporary buffer to save bytes"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	virtual/perl-IO
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300
"

src_test() {
	perl_rm_files "t/release-pod-syntax.t"
	perl-module_src_test
}
