# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=1.21
inherit perl-module

DESCRIPTION="Rounded or exact English expression of durations"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test )
"

src_test() {
	perl_rm_files t/release-{02_pod,03_pod_cover}.t
	perl-module_src_test
}
