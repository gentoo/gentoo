# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSHERER
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Inheritable, overridable class data"
# License note: Artistic only for one file
# https://rt.cpan.org/Public/Bug/Display.html?id=132835
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PERL_RM_FILES=(
	t/pod.t
	t/pod-coverage.t
)
