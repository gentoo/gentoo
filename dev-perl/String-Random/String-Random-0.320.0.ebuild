# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="Perl module to generate random strings based on a pattern"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="dev-perl/Module-Build"
