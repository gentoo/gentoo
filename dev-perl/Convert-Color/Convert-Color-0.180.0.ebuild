# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.18
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Color space conversions and named lookups"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/meta
	dev-perl/Module-Pluggable
	dev-perl/List-UtilsBy
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.400.400
"

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
