# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="An implementation of the Levenshtein edit distance"

SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
