# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STIGTSP
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Perl extension for merging IPv4 or IPv6 CIDR addresses"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

PERL_RM_FILES=( "t/podcov.t" "t/pod.t" )
