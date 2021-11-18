# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ANDYA
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="IPC::ShareLite module for perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
BDEPEND="test? ( virtual/perl-Test-Simple )"

PERL_RM_FILES=( t/pod.t )
