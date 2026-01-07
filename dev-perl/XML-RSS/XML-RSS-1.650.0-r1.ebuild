# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.65
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Basic framework for creating and maintaining RSS files"
HOMEPAGE="https://perl-rss.sourceforge.net/"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 x86 ~x64-macos"

RDEPEND="
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	dev-perl/HTML-Parser
	dev-perl/XML-Parser
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"

PERL_RM_FILES=(
	"t/pod.t" "t/pod-coverage.t"
	"t/cpan-changes.t" "t/style-trailing-space.t"
)
