# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=0.018
inherit perl-module

DESCRIPTION="Runtime module handling"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

src_test() {
	perl_rm_files t/pod_cvg.t t/pod_syn.t
	perl-module_src_test
}
