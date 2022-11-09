# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MATTLAW
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Module name tools and transformations"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"

RDEPEND=""
BDEPEND="
	>=dev-perl/Module-Build-0.400.0
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( t/99..pod.t )
