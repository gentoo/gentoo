# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TRIZEN
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Perl module to get and parse the Linux .desktop files"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	dev-perl/Module-Build
"

PERL_RM_FILES=( t/pod-coverage.t t/pod.t )
