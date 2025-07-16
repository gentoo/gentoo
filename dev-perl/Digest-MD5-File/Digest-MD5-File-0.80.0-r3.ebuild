# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DMUEY
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Perl extension for getting MD5 sums for files and urls"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}"
