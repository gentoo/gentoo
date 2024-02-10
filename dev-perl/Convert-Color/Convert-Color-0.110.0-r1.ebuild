# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.11
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Color space conversions and named lookups"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	dev-perl/Module-Pluggable
	dev-perl/List-UtilsBy
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Number-Delta
	)
"

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
