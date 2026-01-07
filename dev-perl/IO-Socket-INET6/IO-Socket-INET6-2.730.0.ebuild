# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.73
inherit perl-module

DESCRIPTION="Work with IO sockets in IPv6"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-perl/Socket6
"
BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
"

PERL_RM_FILES=(
		t/pod-coverage.t
		t/pod.t
		t/style-trailing-space.t
	)
