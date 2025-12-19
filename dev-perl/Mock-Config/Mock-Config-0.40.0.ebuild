# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Temporarily set Config or XSConfig values"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
LICENSE="Artistic-2"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t t/manifest.t
	perl-module_src_test
}
