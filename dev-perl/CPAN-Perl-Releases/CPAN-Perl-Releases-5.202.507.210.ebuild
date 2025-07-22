# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=5.20250721
inherit perl-module

DESCRIPTION="Mapping Perl releases on CPAN to the location of the tarballs"

SLOT="0"
KEYWORDS="~amd64 ~x86"

PERL_RM_FILES=( "t/author-pod-coverage.t" "t/author-pod-syntax.t" )
