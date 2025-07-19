# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.006022
inherit perl-module

DESCRIPTION="(DEPRECATED) Adding keywords to perl, in perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/B-Hooks-EndOfScope-0.50.0
	>=dev-perl/B-Hooks-OP-Check-0.190.0
	>=virtual/perl-Scalar-List-Utils-1.110.0
	dev-perl/Sub-Name
"
BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	test? (
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.88
	)
"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
