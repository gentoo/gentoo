# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.63

inherit perl-module

DESCRIPTION="Various subroutines to format text"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=dev-perl/Module-Build-0.280.0
"

PERL_RM_FILES=( "t/pod-coverage.t" "t/cpan-changes.t" "t/pod.t" "t/style-trailing-space.t" )
