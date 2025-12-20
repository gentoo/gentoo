# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MICHIELB
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Object to handle .desktop files"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	>=dev-perl/File-BaseDir-0.30.0
	virtual/perl-File-Path
	virtual/perl-File-Spec
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/05_pod_cover.t t/06_changes.t t/04_pod_ok.t
	perl-module_src_test
}
