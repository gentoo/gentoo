# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CAPOEIRAB
DIST_VERSION=9999.32
inherit perl-module

DESCRIPTION="Simple and Efficient Reading/Writing/Modifying of Complete Files"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-File-Spec-3.10.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Scalar-List-Utils-1.0.0
	)
"

mydoc="extras/slurp_article.pod"
