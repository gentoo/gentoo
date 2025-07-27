# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GWILLIAMS
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Parse and format W3CDTF datetime strings"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	dev-perl/DateTime
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=virtual/perl-Test-Simple-0.610.0
	)
"

src_prepare() {
	use test && perl_rm_files t/pod.t t/pod_coverage.t
	perl-module_src_prepare
}
