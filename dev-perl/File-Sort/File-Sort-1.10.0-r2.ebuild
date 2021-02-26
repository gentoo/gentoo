# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CNANDOR
DIST_VERSION=1.01
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Sort a file or merge sort multiple files"
LICENSE="|| ( Artistic GPL-1+ ) examples? ( Artistic )"
SLOT="0"
KEYWORDS="~amd64 x86"
