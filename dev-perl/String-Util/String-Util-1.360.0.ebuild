# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BAKERSCOT
DIST_VERSION=1.36
inherit perl-module

DESCRIPTION="String processing utility functions"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"

PERL_RM_FILES=(
	t/author-pod-syntax.t
)
