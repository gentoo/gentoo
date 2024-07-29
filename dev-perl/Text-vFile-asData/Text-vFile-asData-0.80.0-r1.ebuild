# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCLAMP
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Perl module to parse vFile formatted files into data structures"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="dev-perl/Class-Accessor-Chained"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
