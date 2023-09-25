# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMTM
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Inheritable, overridable class data"
# License note: Artistic only for one file
# https://rt.cpan.org/Public/Bug/Display.html?id=132835
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

PERL_RM_FILES=(
	t/pod.t
	t/pod-coverage.t
)
