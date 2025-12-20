# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Change and print terminal line settings"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

PERL_RM_FILES=( t/98-pod-coverage.t t/99-pod.t )
