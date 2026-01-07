# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.7
inherit perl-module

DESCRIPTION="Provide utility methods for factory classes"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
"

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
