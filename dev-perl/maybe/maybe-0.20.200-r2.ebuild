# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DEXTER
DIST_VERSION=0.0202
inherit perl-module

DESCRIPTION="Use a Perl module and ignore error if can't be loaded"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	dev-perl/Module-Build"
