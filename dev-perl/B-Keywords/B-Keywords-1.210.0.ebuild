# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RURBAN
DIST_VERSION=1.21
inherit perl-module

DESCRIPTION="Lists of reserved barewords and symbol names"

# GPL-2 - no later clause
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
PERL_RM_FILES=(
	"t/z_kwalitee.t"
	"t/z_perl_minimum_version.t"
	"t/z_meta.t"
	"t/z_pod-coverage.t"
	"t/z_pod.t"
)
