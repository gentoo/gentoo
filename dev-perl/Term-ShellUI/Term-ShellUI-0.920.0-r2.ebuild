# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRONSON
DIST_VERSION=0.92
inherit perl-module

DESCRIPTION="A fully-featured shell-like command line environment"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Term-ReadLine-Gnu
"
BDEPEND="${RDEPEND}
"
