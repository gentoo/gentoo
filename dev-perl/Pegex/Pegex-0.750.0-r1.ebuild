# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=INGY
DIST_VERSION=0.75
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Acmeist PEG Parser Framework"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-perl/File-ShareDir-Install
	>=dev-perl/XXX-0.350.0
	>=dev-perl/YAML-PP-0.19.0
"
BDEPEND="
	${RDEPEND}
	test? ( dev-perl/Tie-IxHash )
"

src_test() {
	perl_rm_files t/author-*
	perl-module_src_test
}
