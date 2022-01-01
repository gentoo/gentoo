# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.443
inherit perl-module

DESCRIPTION="Test file attributes"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.950.0
		dev-perl/Test-utf8
	)
"
src_prepare() {
	if use test; then
		perl_rm_files t/pod.t t/pod_coverage.t t/test_manifest
		sed -i -e '/Test::Manifest/d' Makefile.PL || die "Can't patch Makefile.PL"
	fi
	perl-module_src_prepare
}
