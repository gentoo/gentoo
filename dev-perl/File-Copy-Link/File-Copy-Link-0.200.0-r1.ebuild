# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RMBARKER
DIST_VERSION=0.200
inherit perl-module

DESCRIPTION="Perl extension for replacing a link by a copy of the linked file"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"

BDEPEND="
	>=dev-perl/Module-Build-0.380.0
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
