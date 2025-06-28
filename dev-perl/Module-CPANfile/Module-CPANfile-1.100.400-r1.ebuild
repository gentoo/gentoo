# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=1.1004
inherit perl-module

DESCRIPTION="Parse cpanfile"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-CPAN-Meta-2.120.910
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/File-pushd
		>=virtual/perl-Test-Simple-0.880.0
	)
"

PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
