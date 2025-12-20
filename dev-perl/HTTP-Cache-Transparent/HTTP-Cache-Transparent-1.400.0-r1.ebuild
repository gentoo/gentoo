# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MATTIASH
DIST_VERSION=1.4
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Cache the result of http get-requests persistently"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~riscv ~sparc x86"

RDEPEND="
	dev-perl/libwww-perl
	virtual/perl-Digest-MD5
	virtual/perl-Storable
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-RequiresInternet
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
