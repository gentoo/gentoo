# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JHI
DIST_VERSION=1.2911
inherit perl-module

DESCRIPTION="Perl module for BSD process resource limit and priority functions"
LICENSE="|| ( Artistic-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
