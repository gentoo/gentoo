# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANDYA
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="IPC::ShareLite module for perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

PERL_RM_FILES=( t/pod.t )
