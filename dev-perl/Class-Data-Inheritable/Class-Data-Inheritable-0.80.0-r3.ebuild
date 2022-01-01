# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TMTM
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Inheritable, overridable class data"
# License note: Artistic only for one file
# https://bugs.gentoo.org/728662
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PERL_RM_FILES=(
	t/pod.t
	t/pod-coverage.t
)
